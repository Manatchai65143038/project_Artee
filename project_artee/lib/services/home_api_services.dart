import 'dart:convert';
import 'package:http/http.dart' as http;

// สมบูรณ์

class HomeService {
  static const String baseUrl = "http://10.0.2.2:3000/api/admin/menu";

  /// ดึงข้อมูลเมนูทั้งหมด
  static Future<List<dynamic>> fetchMenus() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to load menus");
    }
  }

  /// อัพเดตค่า Home ของเมนู
}
