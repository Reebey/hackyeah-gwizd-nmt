import 'dart:convert';

import 'package:gwizd/models/auth_model.dart';
import 'package:gwizd/utility/jwt_token_store.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _singleton = ApiClient._internal();
  final String baseUrl; // Replace with your API base URL
  final String defaultHeader;

  factory ApiClient() {
    return _singleton;
  }

  ApiClient._internal()
      : baseUrl = 'http://192.168.43.164:8080',
        defaultHeader = 'application/json'; // Replace with your API base URL

  http.Client get client => http.Client();

  Future<Map<String, String>> getHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final authToken =
        await retrieveToken(); // Implement getAuthToken as described earlier

    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    return headers;
  }

  Future<http.Response> sendPost(String url, Object? body) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$url'),
      headers: await getHeaders(),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to send post');
    }
  }

  Future<http.Response> sendGet(String url) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$url'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      print(Uri.parse('$baseUrl/$url').toString());
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to send get');
    }
  }

  Future<http.Response> getAnimals() async {
    return await sendGet('api/Animal/Animals');
  }

  Future<http.Response> postLogin(LoginModel model) async {
    final response = await sendPost(
      'api/Auth/Login',
      model.toJson(),
    );
    return response;
  }

  Future<http.Response> postRegister(RegisterModel model) async {
    final response = await sendPost(
      'api/Auth/Register',
      model.toJson(),
    );
    return response;
  }
}
