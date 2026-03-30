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
      'rating_score': 4.5,
      'rating_count': 10,
      'avatar_url': null,
    },
  );
  testWidgets('ItemWidget displays the title correctly', (WidgetTester tester) async {
    // increase the size of the viewport so we don't get overflow errors
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemCard(item: mockItem),
        ),
      ),
    );
    // after the test is done, reset the view to avoid affecting other tests
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    expect(find.text('Vintage Camera'), findsOneWidget);
  });

}