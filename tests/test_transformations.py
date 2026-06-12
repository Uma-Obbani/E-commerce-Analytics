from src.app.services.transformation_service import flatten_results


def test_flatten_results():

    results = [
        {
            "uuid": "123",
            "created_on": "2025-01-01",
            "account": {
                "holder": "John Doe",
                "iban": "DE123456789",
                "bic": "ABCDEF",
                "bank_name": "Test Bank"
            }
        }
    ]

    rows = flatten_results(results)

    assert len(rows) == 1

    assert rows[0]["finance_uuid"] == "123"

    assert rows[0]["holder"] == "John Doe"

    assert rows[0]["iban"] == "DE123456789"

    assert rows[0]["bank_name"] == "Test Bank"