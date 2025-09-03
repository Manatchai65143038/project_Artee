import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderTrack {
  final int trackOrderID;
  final String trackStateName;

  OrderTrack({required this.trackOrderID, required this.trackStateName});

  factory OrderTrack.fromJson(Map<String, dynamic> json) {
    return OrderTrack(
      trackOrderID: json["trackOrderID"],
      trackStateName: json["trackStateName"],
    );
  }
}

class OrderTrackService {
  // ใช้ 10.0.2.2 สำหรับ Android Emulator
  static const String baseUrl = "http://10.0.2.2:3000/api/staff/orderTrack";

  /// ดึงข้อมูลทั้งหมด
  static Future<List<OrderTrack>> fetchOrderTracks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => OrderTrack.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load order tracks");
    }
  }

  /// ดึงสถานะตาม trackOrderID
  static Future<OrderTrack?> fetchOrderTrackById(int id) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      try {
        final jsonItem = data.firstWhere((e) => e["trackOrderID"] == id);
        return OrderTrack.fromJson(jsonItem);
      } catch (e) {
        return null;
      }
    } else {
      throw Exception("Failed to load order track by ID");
    }
  }
}
