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

  testWidgets('UserWidget displays the rating correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserWidget(userName: 'Test User', rating: 4.5, reviews: 10),
        ),
      ),
    );
    expect(find.text('4.50'), findsOneWidget);
  });

  testWidgets('UserWidget displays the number of reviews correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserWidget(userName: 'Test User', rating: 4.5, reviews: 10),
        ),
      ),
    );
    expect(find.text('· 10 reviews'), findsOneWidget);
  });

  testWidgets('UserWidget displays no reviews correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserWidget(userName: 'Test User', rating: 0.0, reviews: 0),
        ),
      ),
    );
    expect(find.text('· 0 reviews'), findsOneWidget);
  });

  testWidgets('UserWidget displays default icon when no avatarUrl is provided', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserWidget(userName: 'No Avatar Test User', rating: 4.5, reviews: 10),
        ),
      ),
    );
    expect(find.byIcon(Icons.person_2), findsOneWidget);
  });

  testWidgets('UserWidget displays the star icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserWidget(userName: 'Test User', rating: 4.5, reviews: 10),
        ),
      ),
    );
    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}