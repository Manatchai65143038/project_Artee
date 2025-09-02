import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  static const String baseUrl = "http://10.0.2.2:3000"; // เปลี่ยนเป็น API จริง

  static Future<Map<String, dynamic>> generateOrder(int tableNo) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/staff"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"tableNo": tableNo}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        final table = result["tableNo"];
        final order = result["orderNo"];

        final authUrl =
            "$baseUrl/api/auth/customer?tableId=$table&orderId=$order";

        return {
          "success": true,
          "message": "สร้าง QR code สำเร็จ",
          "data": {"orderId": order, "authUrl": authUrl},
        };
      } else {
        return {"success": false, "message": "ไม่สามารถสร้างออร์เดอร์ได้"};
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }
}
