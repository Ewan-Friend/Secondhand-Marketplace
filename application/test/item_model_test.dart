import 'dart:math';

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

    test('Item.toJson should correctly serialize all fields', () {
      final item = Item(
        id: '12345',
        sellerId: 'user_99',
        title: 'Vintage Camera',
        description: 'A beautiful vintage camera',
        rating: 4.5,
        price: 120.50,
        location: 'Rome, Italy',
        condition: 'good',
        imageUrls: ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'],
        sellerInfo: {
          'username': 'testuser',
        },
      );

      final json = item.toJson();

      expect(json['id'], '12345');
      expect(json['seller_id'], 'user_99');
      expect(json['title'], 'Vintage Camera');
      expect(json['description'], 'A beautiful vintage camera');
      expect(json['rating'], 4.5);
      expect(json['price'], 120.50);
      expect(json['location'], 'Rome, Italy');
      expect(json['condition'], 'good');
      expect(json['image_urls'], isA<List<String>>());
      expect(json['image_urls'].length, 2);
      expect(json['seller_info']['username'], 'testuser');
    });

    test('Item fromJson -> toJson round-trip should preserve data', () {
      final originalJson = {
        'id': '12345',
        'seller_id': 'user_99',
        'title': 'Vintage Camera',
        'description': 'Great condition',
        'rating': 4.5,
        'price': 120.50,
        'location': 'Rome, Italy',
        'condition': 'good',
        'image_urls': ['https://example.com/image1.jpg'],
        'seller_info': {'username': 'testuser'},
      };

      final item = Item.fromJson(originalJson);
      final resultJson = item.toJson();

      expect(resultJson['id'], originalJson['id']);
      expect(resultJson['seller_id'], originalJson['seller_id']);
      expect(resultJson['title'], originalJson['title']);
      expect(resultJson['description'], originalJson['description']);
      expect(resultJson['rating'], originalJson['rating']);
      expect(resultJson['price'], originalJson['price']);
      expect(resultJson['location'], originalJson['location']);
      expect(resultJson['condition'], originalJson['condition']);
      expect(resultJson['image_urls'], originalJson['image_urls']);
      expect(resultJson['seller_info'], originalJson['seller_info']);
    });
  });
}

// flutter test test/item_model_test.dart