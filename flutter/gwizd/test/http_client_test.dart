import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gwizd/main.dart';
import 'package:gwizd/utility/http_client.dart';

void main() {
  testWidgets('Get animals', (WidgetTester tester) async {
    final apiClient = ApiClient();
    final response = await apiClient.getAnimals();
    expect(response.statusCode, equals(200));
  });
}
