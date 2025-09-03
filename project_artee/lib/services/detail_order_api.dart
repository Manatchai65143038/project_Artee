import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DetailOrder {
  final int detailNo;
  final int orderNo;
  final int menuID;
  final int trackOrderID;
  final int amount;
  final double price;
  final double totalCost;
  final DateTime dateTime;
  final DateTime updateAT;
  final String trackStateName;
  final int tableNo;
  final String menuName;
  final String menuImage;
  final String menuType;

  DetailOrder({
    required this.detailNo,
    required this.orderNo,
    required this.menuID,
    required this.trackOrderID,
    required this.amount,
    required this.price,
    required this.totalCost,
    required this.dateTime,
    required this.updateAT,
    required this.trackStateName,
    required this.tableNo,
    required this.menuName,
    required this.menuImage,
    required this.menuType,
  });

  factory DetailOrder.fromJson(Map<String, dynamic> json) {
    return DetailOrder(
      detailNo: json["detailNo"],
      orderNo: json["orderNo"],
      menuID: json["menuID"],
      trackOrderID: json["trackOrderID"],
      amount: json["amount"],
      price: double.tryParse(json["price"].toString()) ?? 0.0,
      totalCost: double.tryParse(json["totalCost"].toString()) ?? 0.0,
      dateTime: DateTime.parse(json["dateTime"]),
      updateAT: DateTime.parse(json["updateAT"]),
      trackStateName: json["track"]["trackStateName"],
      tableNo: json["order"]["tableNo"],
      menuName: json["menu"]["name"],
      menuImage: json["menu"]["image"],
      menuType: json["menu"]["type"]["name"],
    );
  }
}

class DetailOrderService {
  static final String baseUrl = "http://10.0.2.2:3000/api/staff/orderDetails";

  static Future<List<DetailOrder>> fetchDetailOrders() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      List<DetailOrder> orders =
          data.map((e) => DetailOrder.fromJson(e)).toList();

      // เรียงตาม detailNo

      print(orders);
      return orders;
    } else {
      throw Exception("Failed to load orders");
    }
  }

  /// ✅ อัปเดต trackOrderID ของ orderDetail
  static Future<bool> updateTrack(int detailNo, int trackId) async {
    final url = "$baseUrl/$detailNo";
    final response = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": detailNo, "trackId": trackId}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Update failed: ${response.body}");
      return false;
    }
  }
}
