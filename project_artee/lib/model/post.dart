class Post {
  final int id;
  final String title;
  final String content;
  final bool published;
  final String createdAt;
  final String updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.published,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      published: json['published'],
      createdAt: json['createAt'],
      updatedAt: json['updateAt'],
    );
  }
}
