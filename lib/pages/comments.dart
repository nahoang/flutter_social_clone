import 'package:flutter/material.dart';

import '../widgets/header.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  Comments({
    required this.postId,
    required this.postOwnerId,
    required this.postMediaUrl,
  });

  @override
  CommentsState createState() => CommentsState(
    postId: this.postId,
    postOwnerId: this.postOwnerId,
    postMediaUrl: this.postMediaUrl,
  );
}

class CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  CommentsState({
    required this.postId,
    required this.postOwnerId,
    required this.postMediaUrl,
  });

  buildComments() {
    return Text('Comments');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: 'Comments'),
      body: Column(
        children: [
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: 'Write a comment...'),
            ),
            trailing: OutlineButton(
              onPressed: () => print('add comment'),
              borderSide: BorderSide.none,
              child: Text('Post'),
            ),
          )
        ],
      )
    );
  }
}

class Comment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Comment');
  }
}
