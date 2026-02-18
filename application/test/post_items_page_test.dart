import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:application/pages/post_items_page.dart';

void main() {
  Future<void> pumpPostItemsPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpWidget(const MaterialApp(home: PostItemsPage()));
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('PostItemsPage TextController Tests', () {
    testWidgets('All text fields can be filled independently and retain values', 
        (WidgetTester tester) async {
      await pumpPostItemsPage(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'What are you selling?'),
        'Vintage Camera',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Describe what are you selling'),
        'Excellent condition, barely used',
      );
      await tester.enterText(
        find.widgetWithText(TextField, '0.00'),
        '149.99',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Start typing location'),
        'Zurich',
      );
      await tester.pump();

      expect(find.text('Vintage Camera'), findsOneWidget);
      expect(find.text('Excellent condition, barely used'), findsOneWidget);
      expect(find.text('149.99'), findsOneWidget);
      expect(find.text('Zurich'), findsOneWidget);
    });

    testWidgets('Text fields persist when edited multiple times', 
        (WidgetTester tester) async {
      await pumpPostItemsPage(tester);

      final titleField = find.widgetWithText(TextFormField, 'What are you selling?');
      
      await tester.enterText(titleField, 'Old Camera');
      await tester.pump();
      expect(find.text('Old Camera'), findsOneWidget);

      await tester.enterText(titleField, 'Vintage Camera');
      await tester.pump();
      expect(find.text('Vintage Camera'), findsOneWidget);
      expect(find.text('Old Camera'), findsNothing);
    });

    testWidgets('Condition dropdown updates state dynamically', 
        (WidgetTester tester) async {
      await pumpPostItemsPage(tester);

      final dropdown = find.byType(DropdownButtonFormField<String>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Like New').last);
      await tester.pumpAndSettle();
      expect(find.text('Like New'), findsOneWidget);

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Used').last);
      await tester.pumpAndSettle();
      expect(find.text('Used'), findsOneWidget);
    });

    testWidgets('Price field accepts decimal input', 
        (WidgetTester tester) async {
      await pumpPostItemsPage(tester);

      final priceField = find.widgetWithText(TextField, '0.00');
      
      await tester.enterText(priceField, '99.50');
      await tester.pump();
      expect(find.text('99.50'), findsOneWidget);

      await tester.enterText(priceField, '1234.99');
      await tester.pump();
      expect(find.text('1234.99'), findsOneWidget);
    });
  });
}

// Run with: flutter test test/post_items_page_test.dart
