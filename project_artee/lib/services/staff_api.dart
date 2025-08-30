import 'dart:convert';
import 'package:http/http.dart' as http;

class StaffService {
  // ปรับ URL ให้ตรงกับ Next.js API ของคุณ
  static const String baseUrl = "http://10.0.2.2:3000/api/admin/staff";

  /// GET: ดึงข้อมูล Staff
  static Future<List<dynamic>> fetchStaffs() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true) {
        return jsonData['data'];
      } else {
        throw Exception(jsonData['error'] ?? "ไม่สามารถโหลด Staff ได้");
      }
    } else {
      throw Exception("โหลด Staff ไม่สำเร็จ: ${response.statusCode}");
    }
  }

  /// POST: เพิ่ม Staff
  static Future<void> createStaff(Map<String, dynamic> staffData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(staffData),
    );

    if (response.statusCode != 201) {
      final jsonData = json.decode(response.body);
      throw Exception(jsonData['error'] ?? "เกิดข้อผิดพลาดในการสร้าง Staff");
    }
  }
}
