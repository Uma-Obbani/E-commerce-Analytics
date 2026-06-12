import asyncio

import httpx

from app.clients.bigquery_client import BigQueryClient
from app.services.transformation_service import flatten_results
from app.config.settings import API_URL, HEADERS

# Number of Finance UUIDs processed per API request
BATCH_SIZE = 1000


async def fetch_batch(
    client,
    batch,
    batch_id,
):
    """
    Send a batch of Finance UUIDs to the enrichment API.

    Includes retry handling to recover from temporary
    API/network failures.
    """

    for attempt in range(1, 4):

        try:

            response = await client.post(
                API_URL,
                json={"uuids": batch},
                headers=HEADERS,
            )

            response.raise_for_status()

            results = response.json()["results"]
            
            return {
                "batch_id": batch_id,
                "requested_count": len(batch),
                "returned_count": len(results),
                "results": results,
                "status": "SUCCESS",
            }

        except Exception as e:

            print(
                f"Batch {batch_id} "
                f"Attempt {attempt}/3 Failed: {e}"
            )
    # Mark batch as failed after all retry attempts
    return {
        "batch_id": batch_id,
        "requested_count": len(batch),
        "returned_count": 0,
        "results": [],
        "status": "FAILED",
    }


async def enrich_uuids(uuids):
    """
    Split Finance UUIDs into batches and process
    them concurrently using async API calls.
    """
    
    batches = [
        uuids[i:i + BATCH_SIZE]
        for i in range(
            0,
            len(uuids),
            BATCH_SIZE,
        )
    ]

    print(
        f"Created {len(batches)} batches"
    )

    async with httpx.AsyncClient(
        timeout=300
    ) as client:
        # Execute all API batch requests concurrently
        tasks = [
            fetch_batch(
                client,
                batch,
                batch_id,
            )
            for batch_id, batch in enumerate(
                batches,
                start=1,
            )
        ]

        return await asyncio.gather(*tasks)


def main():
    """
    Main orchestration flow:
    BigQuery UUID queue
        -> Async API enrichment
        -> Transform response
        -> Load enriched IBAN data
    """

    bq_client = BigQueryClient()

    print(
        "Reading UUIDs from BigQuery..."
    )

    uuids = (
        bq_client.get_finance_uuids()
    )

    print(
        f"Retrieved {len(uuids)} UUIDs"
    )

    print(
        "Calling FastAPI..."
    )

    batch_results = asyncio.run(
        enrich_uuids(uuids)
    )

    combined_results = []

    failed_batches = []

    total_requested = 0

    total_returned = 0

    for batch in batch_results:

        total_requested += (
            batch["requested_count"]
        )

        total_returned += (
            batch["returned_count"]
        )

        if batch["status"] == "FAILED":

            failed_batches.append(
                batch["batch_id"]
            )

            continue

        if (
            batch["requested_count"]
            != batch["returned_count"]
        ):

            print(
                f"WARNING: "
                f"Batch {batch['batch_id']} "
                f"requested "
                f"{batch['requested_count']} "
                f"records but received "
                f"{batch['returned_count']}"
            )

        combined_results.extend(
            batch["results"]
        )

    print(
        f"Requested UUIDs: "
        f"{total_requested}"
    )

    print(
        f"Received Records: "
        f"{total_returned}"
    )

    if total_requested != total_returned:

        print(
            "WARNING: "
            "Record count mismatch detected"
        )

    if failed_batches:

        print(
            f"Failed Batches: "
            f"{failed_batches}"
        )

    print(
        "Flattening results..."
    )

    rows = flatten_results(
        combined_results
    )

    print(
        f"Flattened "
        f"{len(rows)} records"
    )

    if not rows:

        print(
            "No rows to load"
        )
        return

    print(
        "Loading results into BigQuery..."
    )

    bq_client.load_results(rows)

    print(
        f"Loaded {len(rows)} rows"
    )

    print(
        "Enrichment completed successfully"
    )


if __name__ == "__main__":
    main()