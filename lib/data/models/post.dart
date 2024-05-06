import 'package:flutter_blog/data/models/user.dart';
import 'package:intl/intl.dart';

class Post {
  int id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  Post.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        content = json["content"],
        user = User.fromJson(json["user"]),
        createdAt = DateFormat("yyyy-mm-dd").parse(json["createdAt"]),
        updatedAt = DateFormat("yyyy-mm-dd").parse(json["updatedAt"]);
}
