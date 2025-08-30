// services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://10.0.2.2:3000/api/auth";

  /// Login
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true) {
        return jsonData; // ส่ง token + staff info
      } else {
        throw Exception(jsonData['error'] ?? "Login ไม่สำเร็จ");
      }
    } else {
      throw Exception("Login ล้มเหลว: ${response.statusCode}");
    }
  }
}
