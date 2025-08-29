import 'dart:convert';
import 'package:http/http.dart' as http;

class StaffService {
  static const String baseUrl = "http://localhost:3000/api";

  static Future<List<Map<String, dynamic>>> fetchStaffs() async {
    final response = await http.get(Uri.parse("$baseUrl/staffs"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to fetch staffs");
    }
  }

  static Future<void> addStaff({
    required String name,
    required String surname,
    required String telNo,
    required String username,
    required String password,
    String? image,
    String? fileID,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/staffs"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": name,
        "surname": surname,
        "telNo": telNo,
        "username": username,
        "password": password,
        "image": image ?? "",
        "fileID": fileID ?? "",
      }),
    );
    if (response.statusCode != 201) throw Exception("Failed to add staff");
  }

  static Future<void> updateStaff(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/staffs/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode != 200) throw Exception("Failed to update staff");
  }

  static Future<void> deleteStaff(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/staffs/$id"));
    if (response.statusCode != 200) throw Exception("Failed to delete staff");
  }
}
