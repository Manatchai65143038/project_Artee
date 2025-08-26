import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.0.2.2:3000/api/posts"; // Android Emulator

  // GET: fetch posts
  Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // เป็น List ของ posts
    } else {
      throw Exception("Failed to load posts: ${response.statusCode}");
    }
  }

  createPost(String s, String t) {}
}
