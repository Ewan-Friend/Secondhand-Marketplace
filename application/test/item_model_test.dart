import 'package:flutter_test/flutter_test.dart';
import 'package:application/models/item_model.dart';

void main() {
  group('Item Model Tests', () {
    test('Item.fromJson should correctly parse backend JSON with images', () {
      final Map<String, dynamic> mockJsonResponse = {
        'id': '12345',
        'seller_id': 'user_99',
        'title': 'Vintage Camera',
        'rating': 4.5,
        'price': 120.50,
        'created_at': '2026-01-22',
        'image_urls': [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg'
        ],
        'seller_info': {
          'id': '550e8400-e29b-41d4-a716-446655440000',
          'username': 'testuser',
          'location': 'Rome, Italy',
          'rating_score': 4.5,
          'rating_count': 76
        }
      };

      final item = Item.fromJson(mockJsonResponse);

      expect(item.id, '12345');
      expect(item.sellerId, 'user_99');
      expect(item.title, 'Vintage Camera');
      expect(item.rating, 4.5);
      expect(item.price, 120.50);
      expect(item.imageUrls.length, 2);
      expect(item.imageUrls[0], 'https://example.com/image1.jpg');

      // Verify seller info 
      expect(item.sellerInfo, isA<Map<String, dynamic>>());
      expect(item.sellerInfo['username'], 'testuser');
      expect(item.sellerInfo['rating_count'], 76);
    });

    test('Item.fromJson should handle missing or null fields gracefully', () {
      final Map<String, dynamic> incompleteJson = {
        'id': '123',
        'title': null, 
        'price': null,
        'seller_info': null, // Test null safety
      };

      final item = Item.fromJson(incompleteJson);

      expect(item.title, 'Untitled');
      expect(item.price, 0.0);
      expect(item.imageUrls, isA<List<String>>());
      expect(item.imageUrls, isEmpty);
      expect(item.sellerInfo, isA<Map<String, dynamic>>());
      expect(item.sellerInfo, isEmpty);
    });
  });
}

// flutter test test/item_model_test.dart