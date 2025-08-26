import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> updateRegister(int postId, bool registered) async {
  final url = Uri.parse("http://10.0.2.2:3000/api/menu/$postId/register");

  final response = await http.put(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"published": registered}),
  );

  if (response.statusCode == 200) {
    print("Post updated: ${response.body}");
  } else {
    print("Failed to update: ${response.statusCode}");
  }
}
