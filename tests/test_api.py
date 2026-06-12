from fastapi.testclient import TestClient

from src.app.main import app


client = TestClient(app)


def test_search_endpoint():

    payload = {
        "uuids": [
            "123",
            "456"
        ]
    }

    headers = {
        "x-wa-auth": "123abcde123",
        "x-wa-key": "123abcde123",
        "authorization": "Bearer test-token"
    }

    response = client.post(
        "/search",
        json=payload,
        headers=headers
    )

    assert response.status_code == 200

    body = response.json()

    assert "results" in body

    assert len(body["results"]) == 2