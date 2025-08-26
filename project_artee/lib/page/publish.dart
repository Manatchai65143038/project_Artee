import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<dynamic> posts = [];
  bool loading = true;

  // แก้เป็น IP ของเครื่องที่รัน Next.js (ถ้าใช้ emulator android → 10.0.2.2)
  final String baseUrl = "http://10.0.2.2:3000/api";

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    setState(() => loading = true);
    try {
      final response = await http.get(Uri.parse("$baseUrl/posts"));
      if (response.statusCode == 200) {
        setState(() {
          posts = jsonDecode(response.body);
          loading = false;
        });
      } else {
        throw Exception("Failed to load posts");
      }
    } catch (e) {
      print(e);
      setState(() => loading = false);
    }
  }

  Future<void> updatePublished(int id, bool published) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/posts/$id/publish"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"published": published}),
      );

      if (response.statusCode == 200) {
        print("Updated post $id to $published");
        fetchPosts(); // รีโหลดข้อมูล
      } else {
        print("Failed to update: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Posts")),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(post["title"]),
              subtitle: Text(post["content"] ?? "No content"),
              trailing: Switch(
                value: post["published"] ?? false,
                onChanged: (value) {
                  updatePublished(post["id"], value);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
