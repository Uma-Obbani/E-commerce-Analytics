from google.cloud import bigquery
import pandas as pd

from app.reporting.excel_report_generator import generate_country_workbooks
from app.reporting.email_service import send_email


def get_report_data():

    client = bigquery.Client()

    query = """
    SELECT
        car_id,
        branch_id,
        market,
        purchase_timestamp,
        iban_before_last4,
        iban_last_active_datetime,
        iban_after_last4
    FROM analytics_engineering_auto1.fct_purchase_iban_change
    """

    return client.query(query).to_dataframe()


def main():

    print("Reading report data...")

    df = get_report_data()

    print(f"Retrieved {len(df)} rows")

    print(df.dtypes)

    # Remove timezone information for Excel
    for col in df.select_dtypes(include=["datetimetz"]).columns:
        df[col] = df[col].dt.tz_localize(None)

    file_name = "IBAN_Change_Report.xlsx"

    generate_country_workbooks(
        df
    )

    # Uncomment later when email works
    send_email()

    print("Monthly report completed")


if __name__ == "__main__":
    main()