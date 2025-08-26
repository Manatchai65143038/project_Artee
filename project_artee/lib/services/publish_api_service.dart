import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> updatePublished(int postId, bool published) async {
  final url = Uri.parse("http://10.0.2.2:3000/api/posts/$postId/publish");

  final response = await http.patch(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"published": published}),
  );

  if (response.statusCode == 200) {
    print("Post updated: ${response.body}");
  } else {
    print("Failed to update: ${response.statusCode}");
  }
}
