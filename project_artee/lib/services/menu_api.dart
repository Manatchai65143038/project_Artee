import 'dart:convert';
import 'package:http/http.dart' as http;

// สมบูรณ์

class MenuService {
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

  /// อัพเดตค่า isAvailable ของเมนู
  static Future<void> updateAvailability(int menuID, bool newValue) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/$menuID"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"isAvailable": newValue}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update menu #$menuID");
    }
  }
}
