import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:application/widgets/user_widget.dart';

void main() {
  testWidgets('UserWidget displays the userName correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserWidget(userName: 'Test User', rating: 4.5, reviews: 10),
        ),
      ),
    );
    expect(find.text('Test User'), findsOneWidget);
  });

  
}