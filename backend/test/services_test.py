import pytest
from unittest.mock import MagicMock
from app import create_app
from app.services import fetch_user_by_id, fetch_item_by_id

@pytest.fixture
def mock_supabase():
    """Creates a mock Supabase client with chained method support."""
    mock_client = MagicMock()
    # This allows us to chain methods like .table().select().eq()
    mock_client.table.return_value.select.return_value.eq.return_value.single.return_value.execute.return_value = MagicMock()
    return mock_client

## --- Tests for fetch_user_by_id ---

def test_fetch_user_success(mock_supabase):
    # Setup mock data
    expected_data = {"id": "123", "username": "test_user"}
    mock_supabase.table().select().eq().single().execute.return_value.data = expected_data

    # Call the function
    result = fetch_user_by_id(mock_supabase, "123")

    # Assertions
    assert result == expected_data
    mock_supabase.table.assert_called_with("profiles")

def test_fetch_user_none_id(mock_supabase):
    assert fetch_user_by_id(mock_supabase, None) is None

def test_fetch_user_error(mock_supabase):
    # Simulate an exception during the execute() call
    mock_supabase.table().select().eq().single().execute.side_effect = Exception("DB Error")
    
    result = fetch_user_by_id(mock_supabase, "123")
    assert result is None


## --- Tests for fetch_item_by_id ---

def test_fetch_item_success(mock_supabase):
    # 1. Setup mock for the item and its nested image data
    mock_item_data = {
        "id": "item_456", 
        "seller_id": "user_123", 
        "title": "Vintage Camera",
        "price": "150.00",
        "rating": "4.5",
        "item_images": [{"image_url": "http://example.com/img.jpg"}]
    }
    
    # 2. Setup mock for the seller info (called via fetch_user_by_id)
    mock_seller_data = {"id": "user_123", "username": "cameraguy"}

    # Configure the mock to return item data first, then seller data
    # .execute() is called twice: once for items, once for profiles
    mock_supabase.table().select().eq().single().execute.side_effect = [
        MagicMock(data=mock_item_data),
        MagicMock(data=mock_seller_data)
    ]

    result = fetch_item_by_id(mock_supabase, "item_456")

    # 3. Assertions
    assert result["id"] == "item_456"
    assert result["seller_info"] == mock_seller_data
    assert result["price"] == 150.0  # Check float conversion
    assert "http://example.com/img.jpg" in result["image_urls"]
    
    # Verify the item table was queried
    mock_supabase.table.assert_any_call("items")

def test_fetch_item_not_found(mock_supabase):
    # Simulate the item table returning nothing
    mock_supabase.table().select().eq().single().execute.side_effect = Exception("No rows found")
    
    result = fetch_item_by_id(mock_supabase, "invalid_id")
    assert result is None