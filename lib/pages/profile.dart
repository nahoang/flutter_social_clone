import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_clone/pages/edit_profile.dart';
import 'package:flutter_social_clone/pages/home.dart';
import 'package:flutter_social_clone/widgets/header.dart';
import 'package:flutter_social_clone/widgets/progress.dart';

import '../models/user.dart';
import '../widgets/post.dart';

class Profile extends StatefulWidget {
  final String? profileId;

  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isFollowing = false;
  final String? currentUserId = currentUser?.id;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    getProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followingRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .get();
    setState(() {
       followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(widget.profileId)
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef.doc(widget.profileId).collection('userPosts')
    .orderBy('timestamp', descending: true)
    .get();

    setState(() {
      isLoading = false;
      postCount = snapshot.docs.length;
      posts  = snapshot.docs.map((doc) {
        return Post.fromDocument(doc);
      }).toList();
    });
  }

  buildProfilePost() {
    if (isLoading) {
      return circularProgress();
    }
    return Column(children: posts,);
  }

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(label,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Container buildButton({required String text, VoidCallback? function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 240.0,
          height: 27.0,
          child: Text(text,
              style: TextStyle(
                color: isFollowing ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              )),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFollowing ? Colors.white : Colors.blue,
            border: Border.all(
              color: isFollowing ? Colors.grey : Colors.blue,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  editProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditProfile(
      currentUserId: currentUserId
    )));
  }

  buildProfileButton() {
    //viewing your own profile.
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return buildButton(text: 'Edit Profile', function: editProfile);
    } else if (isFollowing) {
      return buildButton(text: 'Unfollow', function: handleUnfollowUser);
    } else if (!isFollowing) {
      return buildButton(text: 'Follow', function: handleFollowUser);
    }
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });

    //Remove follower
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get().then((doc) {
       if (doc.exists) {
         doc.reference.delete();
       }
    });

    //Remove following
    followingRef.doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // Delete activity
    activityFeedRef.
    doc(widget.profileId)
        .collection('feedItems')
        .doc(currentUserId)
        .get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });
    //Make auth user follower of Another user (Update their followers collection)
    followersRef
      .doc(widget.profileId)
      .collection('userFollowers')
      .doc(currentUserId)
      .set({

    });

    //Put that user on YOur following collection (update your following collection)
    followingRef.doc(currentUserId)
      .collection('userFollowing')
      .doc(widget.profileId)
      .set({

    });

    // Add activity feed item for that user to notify about new followers
    activityFeedRef.
      doc(widget.profileId)
      .collection('feedItems')
      .doc(currentUserId)
      .set({
      'type': 'follow',
      'ownerId': widget.profileId,
      'username': currentUser?.username,
      'userId': currentUserId,
      'userProfileImg': currentUser?.photoUrl,
      'timestamp': timestamp
    });
  }

  buildProfileHeader() {
    return FutureBuilder(
        future: usersRef.doc(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument((snapshot.data) as DocumentSnapshot);
          print('user $user');
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          CachedNetworkImageProvider(user.photoUrl),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildCountColumn('posts', postCount),
                              buildCountColumn('followers', followerCount),
                              buildCountColumn('following', followingCount)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [buildProfileButton()],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 12.0),
                  child: Text(
                    user.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    user.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 2.0),
                  child: Text(
                    user.bio,
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, titleText: 'Profile'),
        body: ListView(
          children: [
            buildProfileHeader(),
            Divider(
              height: 0.0,

            ),
            buildProfilePost(),
          ],
        ));
  }
}
