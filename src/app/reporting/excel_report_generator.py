import pandas as pd


def generate_country_workbooks(df):

    for market in sorted(df["market"].dropna().unique()):

        market_df = (
            df[df["market"] == market]
            .sort_values("iban_last_active_datetime")
        )

        file_name = f"IBAN_Change_Report_{market}.xlsx"

        market_df.to_excel(
            file_name,
            index=False
        )

        print(f"Created: {file_name}")