import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_social_clone/pages/home.dart';
import 'package:flutter_social_clone/widgets/progress.dart';

import '../models/user.dart';

class EditProfile extends StatefulWidget {
  final String? currentUserId;

  EditProfile({ this.currentUserId });


  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  late User user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user.displayName;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 12.0),
          child: Text('Display Name',
          style: TextStyle(color: Colors.grey)),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: 'Update display name',
          ),
        )
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 12.0),
          child: Text('Bio',
              style: TextStyle(color: Colors.grey)),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: 'Update bio',
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit profile',
          style: TextStyle(
            color: Colors.black,
          )
        ),
        actions: [
          IconButton(onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.done, size: 30.0, color: Colors.green),)
        ],
      ),
      body: isLoading ?
              circularProgress() : ListView(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0,),
                  child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                ),
                ),
                Padding(padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      buildDisplayNameField(),
                      buildBioField(),
                    ]
                  )
                ),
                RaisedButton(onPressed: ()  => print('update profile data'),
                  child: Text(
                    'Update profile',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: FlatButton.icon(
                    onPressed: () => print('logout'),
                    icon: Icon(Icons.cancel, color: Colors.red),
                    label: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
