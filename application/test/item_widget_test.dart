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

  Future<void> pumpItemCard(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemCard(item: mockItem),
        ),
      ),
    );
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('basic properties', () {
    testWidgets('ItemCard displays the title correctly', (WidgetTester tester) async {
      await pumpItemCard(tester);
      expect(find.text('Vintage Camera'), findsOneWidget);
    });

    testWidgets('ItemCard displays the price correctly', (WidgetTester tester) async {
      await pumpItemCard(tester);
      expect(find.text('£120.50'), findsOneWidget);
    });

    testWidgets('ItemCard displays the location correctly', (WidgetTester tester) async {
      await pumpItemCard(tester);
      expect(find.text('Rome, Italy'), findsOneWidget);
    });

    testWidgets('ItemCard displays the condition correctly', (WidgetTester tester) async {
      await pumpItemCard(tester);
      expect(find.text('good'), findsOneWidget);
    });
  });

  group('seller information', () {
    testWidgets('ItemCard displays seller username correctly', (WidgetTester tester) async {
      await pumpItemCard(tester);
      expect(find.text('testuser'), findsOneWidget);
    });

    testWidgets('ItemCard displays seller rating correctly', (WidgetTester tester) async {
      await pumpItemCard(tester);
      expect(find.text('4.50'), findsOneWidget);
    });

    testWidgets('ItemCard displays seller review count correctly', (WidgetTester tester) async {
      await pumpItemCard(tester);
      expect(find.text('· 10 reviews'), findsOneWidget);
    });
  });

  
}