import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late final String id;
  late final String username;
  late final String email;
  late final String photoUrl;
  late final String displayName;
  late final String bio;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.displayName,
    required this.bio,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc['id'],
        email: doc['email'],
        username: doc['username'],
        photoUrl: doc['photoUrl'],
        displayName: doc['displayName'],
        bio: doc['bio']
    );
  }
}
