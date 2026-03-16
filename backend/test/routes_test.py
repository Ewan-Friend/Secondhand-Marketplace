import pytest
from unittest.mock import patch, MagicMock
from app import create_app


def test_get_user_profile_success(client):
    # Use a "mock" supabase for testting purposes
    with patch("app.routes.supabase") as mock_supabase:
        mock_response = MagicMock()
        mock_response.data = {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "username": "testuser",
            "location": "London, UK",
            "rating_score": 4.5,
            "rating_count": 10,
            "avatar_url": "https://example.com/avatar.png",
            "bio": "Hello, I am a tester.",
        }

        # Setup mock response
        mock_supabase.table.return_value.select.return_value.eq.return_value.single.return_value.execute.return_value = mock_response

        #  <uuid:user_id>
        test_uuid = "550e8400-e29b-41d4-a716-446655440000"

        response = client.get(f"/api/profile/{test_uuid}")
        data = response.get_json()

        assert response.status_code == 200
        assert data["status_code"] == 200

        profile = data.get("table_data", {})
        assert profile["username"] == "testuser"
        assert profile["rating_count"] == 10

        assert isinstance(profile["rating_score"], (int, float))
        assert isinstance(profile["username"], str)
        assert isinstance(profile["id"], str)


def test_get_status(client):
    # Test the /status endpoint
    response = client.get("/api/status")
    data = response.get_json()

    assert response.status_code == 200
    assert data["status_code"] == 200
    assert "message" in data
    assert "successfully connected" in data["message"].lower()


def test_get_current_user(client):
    # Test GET /me endpoint
    response = client.get("/api/me")
    data = response.get_json()

    assert response.status_code == 200
    assert data["status_code"] == 200
    assert "data" in data
    assert data["data"]["display_name"] == "John Doe"
    assert data["data"]["rating"] == 4.7


def test_update_current_user_success(client):
    # Test PATCH /me endpoint with valid data
    response = client.patch(
        "/api/me",
        json={
            "display_name": "Jane Doe",
            "location": "Manchester, UK",
            "avatar_url": "https://example.com/avatar.jpg",
        },
    )
    data = response.get_json()

    assert response.status_code == 200
    assert data["status_code"] == 200
    assert "Profile updated successfully" in data["message"]
    assert data["data"]["display_name"] == "Jane Doe"
    assert data["data"]["location"] == "Manchester, UK"


def test_update_current_user_display_name_too_long(client):
    # Test PATCH /me with display name exceeding 40 chars
    response = client.patch(
        "/api/me",
        json={
            "display_name": "A" * 41  # 41 characters
        },
    )
    data = response.get_json()

    assert response.status_code == 400
    assert "40 characters or less" in data["message"]


def test_get_reviews_default_user(client):
    # Test GET /reviews endpoint
    response = client.get("/api/reviews")
    data = response.get_json()

    assert response.status_code == 200
    assert data["status_code"] == 200
    assert "data" in data
    assert isinstance(data["data"], list)
    assert len(data["data"]) > 0
    assert data["data"][0]["rating"] == 5


def test_get_reviews_with_user_id(client):
    # Test GET /reviews with user_id query param
    response = client.get("/api/reviews?user_id=550e8400-e29b-41d4-a716-446655440000")
    data = response.get_json()

    assert response.status_code == 200
    assert data["status_code"] == 200
    assert isinstance(data["data"], list)


# run
# pytest -v -s --cov=app --cov-report=term-missing test/
