import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String baseUrl = "http://localhost:3000/api/payments";

  // ✅ ดึงรายการชำระเงิน
  static Future<List<Map<String, dynamic>>> fetchPayments() async {
    final response = await http.get(Uri.parse("$baseUrl/payments"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to load payments");
    }
  }

  // ✅ เพิ่มการชำระเงินใหม่
  static Future<void> addPayment({
    required int orderNo,
    required double totalCost,
    required String status,
    required int staffID,
    required int methodID,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/payments"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "orderNo": orderNo,
        "totalCost": totalCost,
        "status": status,
        "staffID": staffID,
        "methodID": methodID,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to add payment");
    }
  }

  // ✅ อัปเดตสถานะการชำระเงิน
  static Future<void> updateStatus(int paymentNo, String newStatus) async {
    final response = await http.put(
      Uri.parse("$baseUrl/payments/$paymentNo/status"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"status": newStatus}),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update status");
    }
  }
}
