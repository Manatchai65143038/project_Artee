import 'package:flutter/material.dart';
import 'package:project_artee/services/api_service.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final ApiService api = ApiService();
  late Future<List<dynamic>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = api.fetchPosts();
  }

  void _addPost() async {
    //final newPost = await api.createPost("New title", "Hello from Flutter!");
    setState(() {
      postsFuture = api.fetchPosts(); // reload posts
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: _addPost)],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(posts[index]["title"] ?? ""),
                  subtitle: Text(posts[index]["content"] ?? ""),
                );
              },
            );
          }
        },
      ),
    );
  }
}
