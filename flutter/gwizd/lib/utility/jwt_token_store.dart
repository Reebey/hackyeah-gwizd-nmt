import 'package:shared_preferences/shared_preferences.dart';

// Store the JWT token
Future<void> storeToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('jwt_token', token);
}

// Retrieve the JWT token
Future<String?> retrieveToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}

// Remove the JWT token
Future<bool> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove('jwt_token');
}
