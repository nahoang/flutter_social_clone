import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_clone/pages/home.dart';
import 'package:flutter_social_clone/widgets/header.dart';
import 'package:flutter_social_clone/widgets/progress.dart';

import '../widgets/post.dart';

class PostScreen extends StatelessWidget {
  late final String userId;
  late final String postId;

  PostScreen({required this.userId, required this.postId });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef.doc(userId).collection('userPosts').doc(postId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        Post post = Post.fromDocument(snapshot.data as DocumentSnapshot);
        return Center(
          child: Scaffold(
            appBar: header(context, titleText: post.description),
            body: ListView(
              children: [
                Container(
                  child: post,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
