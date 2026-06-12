def flatten_results(results):
    """
    Transform nested IBAN API responses into a flat structure
    suitable for BigQuery loading.
    """

    transformed_rows = []

    for item in results:

        transformed_rows.append({

            "finance_uuid": item["uuid"],

            "created_on": item["created_on"],

            "holder": item["account"]["holder"],

            "iban": item["account"]["iban"],

            "bic": item["account"]["bic"],

            "bank_name": item["account"]["bank_name"]
        })

    return transformed_rows

   