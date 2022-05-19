import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_clone/pages/home.dart';
import 'package:flutter_social_clone/pages/post_screen.dart';
import 'package:flutter_social_clone/pages/profile.dart';
import 'package:flutter_social_clone/widgets/header.dart';
import 'package:flutter_social_clone/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .doc(currentUser?.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    List<ActivityFeedItem> feedItems = [];
    snapshot.docs.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
    });

    // snapshot.docs.forEach((doc) {
    //   print('Activity Feed Item: ${doc.data}');
    // });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange,
        appBar: header(context, titleText: 'Activity Feed'),
        body: Container(
          child: FutureBuilder(
            future: getActivityFeed(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgress();
              }
              return ListView(
                children: snapshot.data as List<ActivityFeedItem>,
              );
            },
          ),
        ));
  }
}

late Widget mediaPreview;
late String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  late final String username;
  late final String userId;
  late final String type; // like or comment
  late final String mediaUrl;
  late final String postId;
  late final String userProfileImg;
  late final String commentData;
  late final Timestamp timestamp;

  ActivityFeedItem({
    required this.username,
    required this.userId,
    required this.type,
    required this.mediaUrl,
    required this.postId,
    required this.userProfileImg,
    required this.commentData,
    required this.timestamp,
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc['username'],
      userId: doc['userId'],
      type: doc['type'],
      mediaUrl: doc['mediaUrl'],
      postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
    );
  }

  showPost(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PostScreen(userId: userId, postId: postId)));
  }

  configureMediaPreview(context) {
    if (type == 'like' || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(mediaUrl),
              )),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == 'like') {
      activityItemText = 'liked your post';
    } else if (type == 'follow') {
      activityItemText = 'is following you';
    } else if (type == 'comment') {
      activityItemText = 'replied: $commentData';
    } else {
      activityItemText = 'Error: unknown type $type';
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => showPost(context),
            child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' $activityItemText',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ])),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}


showProfile(BuildContext context, {required String profileId}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Profile(
        profileId: profileId,
      ),
    ),
  );
}
