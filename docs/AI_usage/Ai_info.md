## 🤖 AI Usage in This Project

### Tools & Scope
#### Tools used:
- Github Copilot: For code completion / suggestions
- Chatgpt 4 / 5 / Google Gemini: for brainstorming ideas and code structuring
- Claude Sonnet 4.5 / Chatgpt 5 / Gemini: For brainstroming and getting help for creating the s3 bucket and cloudfront stuff in aws system.
  

#### Scope of use:
- Generating boilerplate code
- Generating unit tests
- Refactoring
- Structuring some documentation content
- Helping design a basic continuous deployment (CD) setup for the backend
- Asist with structuring and refactoring the Flutter frontend API wiring
- Assisted with AWS CloudFront + S3 configuration
- OIDC IAM role setup for GitHub Action
- CI/CD pipeline structuring for Flutter web deployment.

#### Prohibited use:
- Generating images or videos
- Generating text for documentation
- Generating code that handles secret keys

### Procedure
#### Policies:
- Always subject AI generated code to the same standard of peer review as with groupmates
- The human developer is always held accountable for generated code
#### Coding standards
- AI generated code should be refactored to hold to project code standardisation
- Provide example code when needed

### How to generate quality AI-written code
- Use tailored, specific prompts that reference existing files to provide context
- Do not generate large code blocks, generate a small block at a time and make sure you understand the core concepts fully before implementing
- Always ask how concepts work when stuck with what to do

### Example usages

#### Prompt - Ewan (case 1) 
"create a similiar test but for get_user_profile()"
*context: provided my test for get_items, to be integrated into the same suite*

#### Response [code snippet] - Gemini (case 1)

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

#### Prompt - Ewan (case 2)
"add tests in python for these helper functions that connect to supabase"
*context: provided my ```services.py```, so i could get tests for both functions held within*

#### Response [code snippet] - Gemini (case 2)
```python
import pytest
from unittest.mock import MagicMock
from app import create_app
from app.services import fetch_user_by_id, fetch_item_by_id

@pytest.fixture
def mock_supabase():
...

```

#### Prompt - Ewan
"create a test in tests to test that the home.dart correctly renders"
*GitHub copilot can read my whole repo to make contextual changes*

#### Response - GitHub Copilot

> created ```home_page_test.dart``` in application/test

"Added an injectable APIService hook on HomePage so the widget can be rendered deterministically in tests, then created a widget test that pumps the page with a fake service and a minimal SVG asset bundle. This validates the page renders its core UI and empty state without hitting the network. Changes are in home_page.dart and the new test at home_page_test.dart."

#### Prompt - Ewan  (case 3)
"create a test for the api service with mock http responses"
*Github copilot received ```api_service.dart``` and made contextual changes*

#### Response - GitHub Copilot  (case 3)

> created ```api_service_test.dart``` in application/test
> created ```api_service_test.mocks.dart``` in application/test

"Created a comprehensive test suite for APIService with 10 test cases covering:

checkConnection()

Returns message when backend is reachable
Returns default message when no message field
Throws exception on non-200 status
Throws exception on network error
getItems()

Returns list of items on success
Returns empty list when table_data is empty
Returns empty list when response is empty object
Throws exception on non-200 status
Throws exception on invalid JSON
Filters out non-map items from malformed data
Added mockito and build_runner dependencies, generated mocks, and all tests are passing."


#### Prompt - Emir  (case 4)
Create a GitHub Actions workflow for deploying a Flutter web app to AWS S3 
and invalidating CloudFront.

Constraints:
- Use GitHub OIDC (no long-lived AWS keys)
- Assume an IAM role
- Sync build/web to S3
- Invalidate CloudFront distribution
- The Flutter project is inside the "application/" directory
- Use release build
- Provide clear placeholder comments for role ARN, bucket name, and distribution ID.

#### Response [code snippet] (case 4)
```
name: Deploy Web (S3 + CloudFront)

on:
push:
    branches:
    - 

jobs:
deploy:
    runs-on: ubuntu-latest
    permissions:
    id-token: write
    contents: read

defaults:
  run:
    working-directory: application

steps:
  - uses: 

  - uses: 
    with:
      channel: 

  - run: flutter pub get
  - run: flutter build web --release

  - uses: 
    with:
      role-to-assume: ${{}}
      aws-region: 

  - run: |
      aws cloudfront create-invalidation \
        --distribution-id ${{ }} \
        --paths "/*"
 ```


#### Prompt - Yunbo  (case 5)
*Use VSCode auto write to code efficiently.
Explanation: When I write code through VSCode, GitHub Copilot provides inline suggestions. What I do is just let it write the framework after which I amend it manually.*

#### Response [code snippet] (case 5)
For example
```
SizedBox(
  width: 48,
  child: showBackButton
      ? IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context);
          }
        )
      : const SizedBox(),
),  
```
code like ```child: showBackButton``` can be automatically written in VSCode by Github Copilot.
