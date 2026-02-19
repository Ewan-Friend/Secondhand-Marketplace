import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:application/pages/home_page.dart';
import 'package:application/services/api_service.dart';
import 'package:application/models/item_model.dart';

class _FakeApiService extends APIService {
  @override
  Future<String> checkConnection() async => 'API OK';

  @override
  Future<List<Item>> getItems() async => <Item>[];
}

class _TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('logo-static.svg')) {
      final bytes = Uint8List.fromList(utf8.encode(_kTestSvg));
      return ByteData.view(bytes.buffer);
    }

    throw FlutterError('Unexpected asset request: $key');
  }
}

const String _kTestSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10"></svg>';

void main() {
  testWidgets('HomePage renders core UI elements', (tester) async {
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: _TestAssetBundle(),
        child: MaterialApp(
          home: HomePage(
            apiService: _FakeApiService(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('API OK'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('No items found'), findsOneWidget);
  });
}
