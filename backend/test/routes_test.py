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
                "condition": "no condition",
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
        assert isinstance(item["condition"], str)

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


def test_get_status(client):
    # Test the /status endpoint
    response = client.get("/api/status")
    data = response.get_json()

    assert response.status_code == 200
    assert data["status_code"] == 200
    assert "message" in data
    assert "successfully connected" in data["message"].lower()


def test_get_items_with_user_filter(client):
    # Test /items endpoint with user_id filter
    with (
        patch("app.routes.supabase") as mock_supabase,
        patch("app.routes.fetch_user_by_id") as mock_fetch,
    ):
        mock_response = MagicMock()
        mock_response.data = [
            {
                "id": 1,
                "seller_id": "user1",
                "title": "Filtered Item",
                "created_at": "2024-01-01T12:00:00",
                "description": "Item by specific user",
                "rating": "4.0",
                "price": "25.00",
                "item_images": [{"image_url": "path/to/img.png"}],
            }
        ]

        mock_supabase.table.return_value.select.return_value.limit.return_value.eq.return_value.order.return_value.limit.return_value.execute.return_value = mock_response
        mock_fetch.return_value = {"username": "user1", "rating_count": 5}

        response = client.get("/api/items?user_id=user1")
        data = response.get_json()

        assert response.status_code == 200
        assert data["status_code"] == 200
        assert len(data.get("table_data", [])) == 1
        assert data["table_data"][0]["title"] == "Filtered Item"


def test_get_item_success(client):
    # Test /item/<id> endpoint successful retrieval
    with patch("app.routes.fetch_item_by_id") as mock_fetch:
        mock_fetch.return_value = {
            "id": 1,
            "title": "Test Item",
            "price": 99.99,
            "seller_id": "user1",
        }

        test_uuid = "550e8400-e29b-41d4-a716-446655440000"
        response = client.get(f"/api/item/{test_uuid}")
        data = response.get_json()

        assert response.status_code == 200
        assert data["status_code"] == 200
        assert data["table_data"]["title"] == "Test Item"


def test_post_item_success(client):
    with patch("app.routes.supabase") as mock_supabase:
        mock_response = MagicMock()
        mock_response.data = [
            {
                "id": "1",
                "title": "Test Item",
                "description": "An item used for testing",
                "price": 99.99,
                "seller_id": "user1",
                "rating": 0.0,
                "category_id": "37d39021-f90e-4c62-9be4-2723864e3ceb",
            }
        ]

        mock_supabase.table.return_value.insert.return_value.execute.return_value = (
            mock_response
        )

        example_data = {
            "title": "Test Item",
            "description": "An item used for testing",
            "price": 99.99,
            "seller_id": "user1",
        }

        response = client.post("/api/items", json=example_data)
        data = response.get_json()

        assert response.status_code == 201
        assert data["status_code"] == 201
        assert data["message"] == "Item posted successfully"
        assert data["data"][0]["title"] == "Test Item"

        mock_supabase.table.assert_called_with("items")
        mock_supabase.table.return_value.insert.assert_called_once()


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
    with patch("app.routes.supabase") as mock_supabase:
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
