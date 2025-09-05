import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_artee/services/detail_order_api.dart';

class DetailOrderService {
  static const baseUrl = "http://10.0.2.2:3000/api/admin/menu";

  static Future<List<DetailOrder>> fetchDetailOrders() async {
    final res = await http.get(Uri.parse(baseUrl));
    final data = json.decode(res.body) as List;
    return data.map((e) => DetailOrder.fromJson(e)).toList();
  }

  static Future<bool> acceptOrder(int detailNo) async {
    final res = await http.patch(Uri.parse("$baseUrl/$detailNo/accept"));
    return res.statusCode == 200;
  }
}
