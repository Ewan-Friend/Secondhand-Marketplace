import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:application/pages/profile_page.dart';
import 'package:application/services/api_service.dart';

// initialiing a fake API service for testing purposes
class _FakeApiService extends APIService {
  @override
  Future<String> checkConnection() async => 'API OK';
}