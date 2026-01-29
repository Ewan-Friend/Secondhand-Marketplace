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

## Prompt
"create a similiar test but for get_user_profile()"
*context: provided my test for get_items, to be integrated into the same suite*

## Response [code snippet]
```
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