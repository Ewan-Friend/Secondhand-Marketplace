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
        ]
      };

      final item = Item.fromJson(mockJsonResponse);

      expect(item.id, '12345');
      expect(item.sellerId, 'user_99');
      expect(item.title, 'Vintage Camera');
      expect(item.rating, 4.5);
      expect(item.price, 120.50);
      expect(item.imageUrls.length, 2);
      expect(item.imageUrls[0], 'https://example.com/image1.jpg');
    });

    test('Item.fromJson should handle missing or null fields gracefully', () {
      final Map<String, dynamic> incompleteJson = {
        'id': '123',
        'title': null, 
        'price': null,
      };

      final item = Item.fromJson(incompleteJson);

      expect(item.title, 'Untitled');
      expect(item.price, 0.0);
      expect(item.imageUrls, isA<List<String>>());
      expect(item.imageUrls, isEmpty);
    });
  });
}

// flutter test test/item_model_test.dart