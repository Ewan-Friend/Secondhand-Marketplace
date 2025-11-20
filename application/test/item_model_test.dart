// test/item_model_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

// Assuming your Item Model is in lib/models/item_model.dart
import 'package:application/models/item_model.dart'; 

void main() {
  // 1. Define the mock JSON data structure returned by your Flask API
  const mockJsonString = '''
  [
    {
      "id": "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d",
      "seller_id": "55d89a2e-d30c-4b20-a51d-6a979ba6b7da",
      "title": "Vintage Radio",
      "rating": 0.00,
      "price": 45.00
    },
    {
      "id": "b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e",
      "seller_id": "8a4d7563-75fc-463c-9e0c-489ea3aaaf45",
      "title": "Blue Knit Sweater",
      "rating": 0.00,
      "price": 22.50
    }
  ]
  ''';

  test('Item.fromJson converts raw JSON list to List<Item> correctly', () {
    // Decode the raw JSON string into the List<dynamic> you receive from the API
    final List<dynamic> rawData = json.decode(mockJsonString);
    
    // 2. Apply the exact mapping logic you wanted to test
    final List<Item> items = rawData
        .map((json) => Item.fromJson(json))
        .toList();
    
    // 3. Assertions to confirm the conversion was successful
    
    // Check if the result is a list of the correct type
    expect(items, isA<List<Item>>());
    
    // Check the list size
    expect(items.length, 2); 
    
    // Check properties of the first item
    expect(items[0].title, 'Vintage Radio');
    expect(items[0].price, 45.00);
    expect(items[0].sellerId, '55d89a2e-d30c-4b20-a51d-6a979ba6b7da');
    expect(items[0].rating, 0.00);

    // Check properties of the second item
    expect(items[1].title, 'Blue Knit Sweater');
    expect(items[1].price, 22.50);
    expect(items[1].rating, 0.00);
  });
}