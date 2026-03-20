import pytest
from unittest.mock import patch, MagicMock
from app import create_app


def test_register_user_missing_email(client):
    # Test registration without email
    response = client.post(
        "/api/register", json={"username": "newuser", "password": "SecurePass123!"}
    )
    data = response.get_json()

    assert response.status_code == 400
    assert "Email and password are required" in data["message"]


def test_register_user_missing_username(client):
    # Test registration without username
    response = client.post(
        "/api/register",
        json={"email": "newuser@example.com", "password": "SecurePass123!"},
    )
    data = response.get_json()

    assert response.status_code == 400
    assert "Username is required" in data["message"]


def test_register_user_duplicate_email(client):
    # Test registration with duplicate email
    with patch("app.routes.auth.supabase") as mock_supabase:
        mock_supabase.auth.sign_up.side_effect = Exception(
            "duplicate key value violates unique constraint"
        )

        response = client.post(
            "/api/register",
            json={
                "email": "existing@example.com",
                "username": "newuser",
                "password": "SecurePass123!",
            },
        )
        data = response.get_json()

        assert response.status_code == 409
        assert "Email already registered" in data["message"]


# run
# pytest -v -s --cov=app --cov-report=term-missing test/
