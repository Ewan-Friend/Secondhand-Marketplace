import pytest
from unittest.mock import patch, MagicMock
from app import create_app


@pytest.fixture
def client():
    app = create_app()
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_get_item_data_success(client):
    # Use a "mock" supabase for testting purposes
    with (
        patch("app.routes.supabase") as mock_supabase,
        patch("app.routes.fetch_user_by_id") as mock_fetch,
    ):
        mock_response = MagicMock()
        mock_response.data = [
            {
                "id": 1,
                "seller_id": "abc123",
                "title": "test item",
                "created_at": "2001-01-01T12:00:00",  # Test formatting may be wrong
                "description": "this is an example item used for testing purposes",
                "rating": "2.5",
                "price": "10.10",
                "item_images": [
                    {"image_url": "path/to/img1.png"},
                    {"image_url": "path/to/img2.png"},
                ],
            }
        ]

        # Setup mock response
        mock_supabase.table.return_value.select.return_value.limit.return_value.order.return_value.limit.return_value.execute.return_value = mock_response

        # Returns a mock result of the "fetch_user_by_id" function, which is handled and assigned to Seller info
        # Seller info contained within the item ( unique seller to each item )
        mock_fetch.return_value = {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "username": "testuser",
            "location": "Rome, Italy",
            "rating_score": 4.5,
            "rating_count": 76,
            "avatar_url": "https://example.com/avatar.png",
        }

        # Define response as geting from /items
        response = client.get("/api/items")
        data = response.get_json()

        items = data.get("table_data", [])

        # Check response structure
        print(response.get_json())

        # Test response was got successfully
        assert response.status_code == 200
        assert data["status_code"] == 200

        # Test body isnt empty
        assert len(response.data) > 0

        # Type validation for example item
        item = items[0]
        assert isinstance(item["id"], int)
        assert isinstance(item["seller_id"], str)
        assert isinstance(item["title"], str)
        assert isinstance(item["created_at"], str)
        assert isinstance(item["description"], str)

        # Ensure floating point precision
        assert isinstance(item["rating"], float)
        assert item["rating"] == 2.5
        assert isinstance(item["price"], float)
        assert item["price"] == 10.10

        # Check Image URL list was correctly processed
        assert isinstance(item["image_urls"], list)
        assert len(item["image_urls"]) == 2
        assert item["image_urls"][0] == "path/to/img1.png"

        # Validate seller info is correctly processed
        assert item["seller_info"]["username"] == "testuser"
        assert item["seller_info"]["rating_count"] == 76


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


# run
# pytest -v -s --cov=app --cov-report=term-missing test/
