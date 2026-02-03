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
    expected_item = {"id": "item_456", "title": "Vintage Camera"}
    mock_supabase.table().select().eq().single().execute.return_value.data = expected_item

    result = fetch_item_by_id(mock_supabase, "item_456")

    assert result == expected_item
    # Check that it correctly targets the profiles table (based on your current code)
    mock_supabase.table.assert_called_with("profiles") 

def test_fetch_item_not_found(mock_supabase):
    # Supabase .single() often raises an exception if 0 rows are found
    mock_supabase.table().select().eq().single().execute.side_effect = Exception("No rows found")
    
    result = fetch_item_by_id(mock_supabase, "invalid_id")
    assert result is None