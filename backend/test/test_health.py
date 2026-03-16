import pytest
from unittest.mock import patch, MagicMock
from app import create_app


def test_get_status(client):
    # Test the /status endpoint
    response = client.get("/api/status")
    data = response.get_json()

    assert response.status_code == 200
    assert data["status_code"] == 200
    assert "message" in data
    assert "successfully connected" in data["message"].lower()


# run
# pytest -v -s --cov=app --cov-report=term-missing test/
