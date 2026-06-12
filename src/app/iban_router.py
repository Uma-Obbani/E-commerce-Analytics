from typing import List

from fastapi import APIRouter, Header, HTTPException
from pydantic import BaseModel

from mock_data.iban_mock_data import generate_mock_record

router = APIRouter()


class UUIDRequest(BaseModel):
    """
    Request schema containing Finance UUIDs
    requiring IBAN enrichment.
    """

    uuids: List[str]



@router.post("/search")
def search_accounts(
    payload: UUIDRequest,
    x_wa_auth: str = Header(None),
    x_wa_key: str = Header(None),
    authorization: str = Header(None),
):
    """
    Request schema containing Finance UUIDs
    requiring IBAN enrichment.
    """
    # Validate API authentication headers
    if x_wa_auth != "123abcde123":
        raise HTTPException(
            status_code=401,
            detail="Invalid x-wa-auth"
        )

    if x_wa_key != "123abcde123":
        raise HTTPException(
            status_code=401,
            detail="Invalid x-wa-key"
        )

    if authorization:
        if not authorization.startswith("Bearer "):
            raise HTTPException(
                status_code=401,
                detail="Invalid authorization"
            )

    # Logging

    print(f"Received {len(payload.uuids)} UUIDs")
    print("First 5 UUIDs:", payload.uuids[:5])

    # Generate Mock Results

    filtered_results = [
        generate_mock_record(uuid)
        for uuid in payload.uuids
    ]

    print(f"Generated {len(filtered_results)} records")

    return {
        "results": filtered_results
    }