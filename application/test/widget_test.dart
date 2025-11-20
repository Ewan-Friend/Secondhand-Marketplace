import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Basic math test', () {
    expect(1 + 1, equals(2));
  });

  test('String concatenation test', () {
    final result = 'Hello World';
    expect(result, equals('Hello World'));
  });
}
