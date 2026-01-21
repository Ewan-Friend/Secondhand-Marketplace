import pytest
from unittest.mock import patch, MagicMock
from app import create_app

@pytest.fixture
def client():
    app = create_app()
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client
    
def test_get_data_success(client):

    # Use a "mock" supabase for testting purposes
    with patch('app.routes.supabase') as mock_supabase:
        mock_response = MagicMock()
        mock_response.data = [{
            "id": 1, 
            "seller_id": "abc123",
            "title": "test item",
            "created_at": "2001-01-01T12:00:00", #Test formatting may be wrong
            "description": "this is an example item used for testing purposes",
            "rating": "2.5",
            "price": "10.10",
            "item_images": [
                {"image_url": "path/to/img1.png"},
                {"image_url": "path/to/img2.png"}
            ]}]
        
        mock_supabase.table.return_value.select.return_value.order.return_value.limit.return_value.execute.return_value = mock_response

        # Define response as geting from /items
        response = client.get('/api/items')
        data = response.get_json()

        items = data.get('table_data', [])

        # Check response structure
        print(response.get_json())

        # Test response was got successfully
        assert response.status_code == 200
        assert data['status_code'] == 200

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
        assert isinstance(item['image_urls'], list)
        assert len(item['image_urls']) == 2
        assert item['image_urls'][0] == "path/to/img1.png"

# without response print
# python3 -m pytest test/handshake_supabase_test.py 

# with response print
# python3 -m pytest -s test/handshake_supabase_test.py