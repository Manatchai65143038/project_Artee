import 'dart:convert';
import 'package:http/http.dart' as http;

// ยังไม่สมบูรณ์

class CancelOrderService {
  static const String baseUrl =
      "http://10.0.2.2:3000/api/admin/cancel-order"; // 🔹 เปลี่ยนเป็น API จริง

  /// ดึงข้อมูลการยกเลิกทั้งหมด
  static Future<List<Map<String, dynamic>>> fetchCancelLogs() async {
    final response = await http.get(Uri.parse("$baseUrl/cancel-order-logs"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Failed to load cancel logs");
    }
  }

  /// เพิ่มการยกเลิกใหม่
  static Future<void> addCancelLog({
    required int detailNo,
    required int orderNo,
    required String description,
    required String cancelBy,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/cancel-order-logs"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "detailNo": detailNo,
        "orderNo": orderNo,
        "description": description,
        "cancelBy": cancelBy,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to add cancel log");
    }
  }
}
