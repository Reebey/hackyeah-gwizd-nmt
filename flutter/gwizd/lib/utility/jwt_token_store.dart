import 'package:shared_preferences/shared_preferences.dart';

// Store the JWT token
Future<void> storeToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('jwt_token', token);
}

// Retrieve the JWT token
Future<String?> retrieveToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token') ??
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOlsidXNlckBleGFtcGxlLmNvbSIsInVzZXJAZXhhbXBsZS5jb20iXSwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiIzIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6InN0cmluZyBzdHJpbmciLCJqdGkiOiI1ZmIzMGQzNS00YjM5LTRlY2ItYjAwYy0xMGRmYmJjZTJhNGYiLCJleHAiOjE2OTYyMzA2MTV9.-KFkaA8OwAUAI_Vr2zqwVrrNKQJ96r_1B66Vh8vyFKI';
}

// Remove the JWT token
Future<bool> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove('jwt_token');
}
