import 'dart:convert';
import 'package:http/http.dart' as http;

class Payment {
  final int paymentNo;
  final int orderNo;
  final int totalCost;
  final String status;
  final String methodName;
  final int tableNo;
  final String? image;

  Payment({
    required this.paymentNo,
    required this.orderNo,
    required this.totalCost,
    required this.status,
    required this.methodName,
    required this.tableNo,
    this.image,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentNo: json['paymentNo'],
      orderNo: json['orderNo'],
      totalCost: json['totalCost'],
      status: json['status'],
      methodName: json['method']?['methodName'] ?? "-",
      tableNo: json['order']?['tableNo'] ?? 0,
      image: json['image'],
    );
  }
}

class PaymentService {
  static const String baseUrl = "http://10.0.2.2:3000/api/staff/payment";

  static Future<List<Payment>> fetchPayments() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true) {
        final List paymentsJson = jsonData['data'];
        return paymentsJson.map((p) => Payment.fromJson(p)).toList();
      } else {
        throw Exception("Failed to load payments: ${jsonData['error']}");
      }
    } else {
      throw Exception("Failed to load payments: ${response.statusCode}");
    }
  }

  static Future<bool> confirmPayment(int paymentNo) async {
    final url = "$baseUrl/$paymentNo"; // endpoint /api/staff/payment/[id]
    final response = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "status": "CONFIRMED",
      }), // สมมติ API ใช้ body สำหรับอัปเดต status
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true) {
        return true;
      } else {
        throw Exception("Failed to confirm payment: ${jsonData['error']}");
      }
    } else {
      throw Exception("Failed to confirm payment: ${response.statusCode}");
    }
  }
}
