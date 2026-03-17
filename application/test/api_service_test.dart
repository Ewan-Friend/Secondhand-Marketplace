import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';

import 'package:application/services/api_service.dart';
import 'package:application/models/item_model.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('APIService', () {
    late MockClient mockClient;
    late APIService apiService;

    setUp(() {
      mockClient = MockClient();
      apiService = APIService(client: mockClient);
    });

    group('checkConnection', () {
      test('returns message when backend is reachable', () async {
        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response('{"message":"OK"}', 200),
        );

        final result = await apiService.checkConnection();

        expect(result, equals('OK'));
      });

      test('returns default message when no message field in response', () async {
        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response('{}', 200),
        );

        final result = await apiService.checkConnection();

        expect(result, equals('Backend reachable'));
      });

      test('throws exception on non-200 status code', () async {
        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        expect(
          () => apiService.checkConnection(),
          throwsException,
        );
      });

      test('throws exception on network error', () async {
        when(mockClient.get(any)).thenThrow(Exception('Network error'));

        expect(
          () => apiService.checkConnection(),
          throwsException,
        );
      });
    });

    group('getItems', () {
      test('returns list of items on success', () async {
        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response(
            '''{
              "table_data": [
                {"id": "1", "seller_id": "user1", "title": "Test Item", "description": "A test item", "price": 100, "rating": 4.5, "image_urls": [], "seller_info": {}},
                {"id": "2", "seller_id": "user2", "title": "Another Item", "description": "Another test", "price": 50, "rating": 3.0, "image_urls": [], "seller_info": {}}
              ]
            }''',
            200,
          ),
        );

        final items = await apiService.getItems();

        expect(items, isA<List<Item>>());
        expect(items.length, equals(2));
        expect(items[0].title, equals('Test Item'));
        expect(items[1].price, equals(50));
      });

      test('returns empty list when table_data is empty', () async {
        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response('{"table_data": []}', 200),
        );

        final items = await apiService.getItems();

        expect(items, isEmpty);
      });

      test('returns empty list when response is empty object', () async {
        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response('{}', 200),
        );

        final items = await apiService.getItems();

        expect(items, isEmpty);
      });

      test('throws exception on non-200 status code', () async {
        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response('Server error', 500),
        );

        expect(
          () => apiService.getItems(),
          throwsException,
        );
      });

      test('throws exception on invalid JSON', () async {
        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response('Invalid JSON', 200),
        );

        expect(
          () => apiService.getItems(),
          throwsException,
        );
      });

      test('filters out non-map items from malformed data', () async {
        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response(
            '''{
              "table_data": [
                {"id": "1", "seller_id": "user1", "title": "Valid", "description": "test", "price": 100, "rating": 4.0, "image_urls": [], "seller_info": {}},
                "invalid_string",
                {"id": "2", "seller_id": "user2", "title": "Another", "description": "test", "price": 50, "rating": 4.0, "image_urls": [], "seller_info": {}}
              ]
            }''',
            200,
          ),
        );

        final items = await apiService.getItems();

        expect(items.length, equals(2));
      });
    });

    group('uploadItemImage', () {
      test('returns parsed response on success', () async {
        when(mockClient.send(any)).thenAnswer(
          (_) async => http.StreamedResponse(
            Stream.value(
              utf8.encode(
                '{"message":"Images uploaded successfully","status_code":201,"image_urls":["https://example.com/image.jpg"]}',
              ),
            ),
            201,
          ),
        );

        final multipart = http.MultipartFile.fromString(
          'images',
          'fake-image-data',
          filename: 'test.jpg',
        );

        final result = await apiService.uploadItemImage(
          itemId: 'item-123',
          images: [multipart],
          imageUrls: ['https://existing.example.com/image.jpg'],
        );

        expect(result['status_code'], equals(201));
        expect(result['image_urls'], isA<List>());

        final captured =
            verify(mockClient.send(captureAny)).captured.single as http.BaseRequest;
        expect(captured.method, equals('POST'));
        expect(captured.url.path, equals('/api/items/upload-images'));

        final multipartRequest = captured as http.MultipartRequest;
        expect(multipartRequest.fields['item_id'], equals('item-123'));
        expect(
          multipartRequest.fields['image_urls'],
          equals('["https://existing.example.com/image.jpg"]'),
        );
        expect(multipartRequest.files.length, equals(1));
      });

      test('throws ApiException when backend returns non-2xx', () async {
        when(mockClient.send(any)).thenAnswer(
          (_) async => http.StreamedResponse(
            Stream.value(
              utf8.encode(
                '{"message":"No Item Images provided","status_code":400}',
              ),
            ),
            400,
          ),
        );

        expect(
          () => apiService.uploadItemImage(
            itemId: 'item-123',
            images: const [],
          ),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              contains('No Item Images provided'),
            ),
          ),
        );
      });
    });
  });
}
