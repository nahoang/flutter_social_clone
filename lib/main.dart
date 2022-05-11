import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_clone/pages/home.dart';

void main() async {
  // FirebaseFirestore.instance.settings(
  //   timestampsInSnapshotsEnabled: true,
  // ).then((_) {
  //       print('Timestams enabled in snapshot\n');
  //     }, onError: (_) {
  //   print('Error enabling in snapshot\n');
  // });
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterShare',
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.teal,
      ),
    );
  }
}
