import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_clone/widgets/progress.dart';

import '../widgets/header.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<dynamic> users = [];

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  getUsers() async {
    final QuerySnapshot snapshot = await usersRef.get();

    setState(() {
      users = snapshot.docs;
      print('users: $users');
    });

    // userRef.getDocuments().then((QuerySnapshot snapshot) {
    //   snapshot.documents.forEach((DocumentSnapshot doc) {
    //     print(doc.data);
    //   });
    // });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: Container(
        child: ListView(children: users.map((user) => Text(user['username'])).toList(),)
      )
    );
  }
}
