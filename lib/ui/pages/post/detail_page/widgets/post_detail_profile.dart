import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/data/models/user.dart';

class PostDetailProfile extends StatelessWidget {
  User user;
  PostDetailProfile(this.user);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text("${user.username}"),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network('${baseUrl + user.imgUrl}'),
        ),
        subtitle: Row(
          children: [
            Text("${user.email}"),
            const SizedBox(width: mediumGap),
            const Text("·"),
            const SizedBox(width: mediumGap),
            const Text("Written on "),
            Text("May 25"),
          ],
        )
    );
  }
}
