import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:application/widgets/item_widget.dart';
import 'package:application/models/item_model.dart';

void main() {
  final mockItem = Item(
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
          'rating': 4.5,
          'reviews': 10,
        },
      );
}