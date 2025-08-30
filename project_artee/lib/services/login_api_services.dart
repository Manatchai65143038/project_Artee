import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:3000/api/auth/staff";
  // ^ Android Emulator ใช้ 10.0.2.2 ถ้าเป็นมือถือจริงเปลี่ยนเป็น IP เครื่อง server

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // เก็บ accessToken ไว้ใน SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("accessToken", data["accessToken"]);
      await prefs.setString("staffID", data["staff"]["staffID"]);
      await prefs.setString("staffName", data["staff"]["name"]);
      await prefs.setString("staffEmail", data["staff"]["email"]);
      await prefs.setString("staffRole", data["staff"]["role"]);

      return {"success": true, "data": data};
    } else {
      return {"success": false, "error": data["error"] ?? "Login failed"};
    }
  }
}
