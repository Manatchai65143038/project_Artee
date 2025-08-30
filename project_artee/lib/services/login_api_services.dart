import 'dart:convert';
import 'package:http/http.dart' as http;

//ยังไม่สมบูรณ์

class AuthService {
  static const String baseUrl = "http://10.0.2.2:3000/api/admin/staff/test";

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? "Login failed");
    }

    return data;
  }
}
