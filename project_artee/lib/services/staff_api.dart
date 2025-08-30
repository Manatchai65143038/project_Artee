// services/staff_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class StaffService {
  static const String baseUrl = "http://10.0.2.2:3000/api/admin/staff";

  static Future<List<dynamic>> fetchStaffs() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load staff");
    }
  }

  static Future<void> addStaff(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to add staff");
    }
  }

  static Future<void> updateStaff(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update staff");
    }
  }

  static Future<void> deleteStaff(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete staff");
    }
  }
}
