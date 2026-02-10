## 🤖 AI Usage in This Project

### Tools & Scope
#### Tools used:
- Github Copilot: For code completion / suggestions
- Chatgpt 4 / 5 / Google Gemini: for brainstorming ideas and code structuring

#### Scope of use:
- Generating boilerplate code
- Generating unit tests
- Refactoring
- Structuring some documentation content

#### Prohibited use:
- Generating images or videos
- Generating text for documentation
- Generating code that handles secret keys

### Procedure
#### Policies:
- Always subject AI generated code to the same standard of peer review as with cgroupmates
- The human developer is always held accountable for generated code
#### Coding standards
- AI generated code should be refactored to hold to project code standardisation
- Provide example code when needed

### How to generate quality AI-written code
- Use tailored, specific prompts that reference existing files to provide context
- Do not generate large code blocks, generate a small block at a time and make sure you understand the core concepts fully before implementing
- Always ask how concepts work when stuck with what to do

### Example usages

#### Prompt (case 1)
"create a similiar test but for get_user_profile()"
*context: provided my test for get_items, to be integrated into the same suite*

#### Response [code snippet] (case 1)

```python
from unittest.mock import patch, MagicMock

def test_get_user_profile_success(client):
    # Use a "mock" supabase specifically in the services file where it's now defined
    with patch("services.supabase") as mock_supabase:
        # Mocking the Supabase response for a single profile record
        mock_response = MagicMock()
        mock_response.data = {
            "id": "abc123-uuid-format", # profiles table uses uuid
            "username": "testuser",      # text field
            "location": "London, UK",    # text field
            "rating_score": 4.5,         # numeric field
            "rating_count": 10,          # int4 field
            "avatar_url": "https://example.com/avatar.png",
            "bio": "Hello, I am a tester."
        }

        # Setup the mock chain for .table().select().eq().single().execute()
        # Note: Added .single() to match the logic for fetching one profile
        mock_supabase.table.return_value.select.return_value.eq.return_value.single.return_value.execute.return_value = mock_response

        # Define the test UUID (matches the route parameter <uuid:user_id>)
        test_uuid = "abc123-uuid-format"
        
        # Execute the GET request to the profile route
        response = client.get(f"/api/profile/{test_uuid}")
        data = response.get_json()

        # Assertions to verify the API behavior
        assert response.status_code == 200
        assert data["status_code"] == 200
        
        # Data validation
        profile = data.get("data", {})
        assert profile["username"] == "testuser"
        assert profile["rating_count"] == 10
        
        # Type validation based on database schema
        assert isinstance(profile["rating_score"], (int, float))
        assert isinstance(profile["username"], str)
        assert isinstance(profile["id"], str)
```

#### Prompt (case 2)
"add tests in python for these helper functions that connect to supabase"
*context: provided my ```services.py```, so i could get tests for both functions held within*

#### Response [code snippet] (case 2)
```python
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
```