import os

from dotenv import load_dotenv
from google.cloud import bigquery


load_dotenv()


PROJECT_ID = os.getenv("GCP_PROJECT_ID")
DATASET = os.getenv("BQ_DATASET")


client = bigquery.Client(
    project=PROJECT_ID
)


def get_customer_context():

    query = f"""

    SELECT
        CAST(customer_id AS STRING) as customer_id,
        ai_marketing_summary

    FROM `{PROJECT_ID}.{DATASET}.mart_ai_marketing_copilot`

    """

    df = client.query(
        query
    ).to_dataframe()

    return df


if __name__ == "__main__":

    df = get_customer_context()

    print(df.head())

    print(
        f"Loaded {len(df)} records"
    )