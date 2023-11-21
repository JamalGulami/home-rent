import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamal_rahnamaie/utils/appconstent.dart';
import 'package:jamal_rahnamaie/widgets/subtext.dart';

class CommentScreen extends StatefulWidget {
  final String productId;

  const CommentScreen({super.key, required this.productId});

  @override
  CommentScreenState createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Comment> comments = [];
  User? user = FirebaseAuth.instance.currentUser;

  bool isFilled = false;
  @override
  void initState() {
    super.initState();
    // Fetch comments for the specific product ID
    _fetchComments();
  }

  void _fetchComments() async {
    final commentsSnapshot = await _firestore
        .collection('comments')
        .where('productId', isEqualTo: widget.productId)
        .orderBy('timestamp', descending: true)
        .get();

    final commentsList = commentsSnapshot.docs.map((doc) {
      final data = doc.data();
      if (data.containsKey('userid')) {
        return Comment(
          userId: data['userid'],
          userName: data['userName'],
          userProfileImageUrl: data['userProfileImageUrl'],
          commentText: data['commentText'],
          timestamp: data['timestamp'],
        );
      } else {
        // Handle the case where 'userid' field is missing in the document
        // You can return a default value or null, or take appropriate action.
        return Comment(
          userId: user!.uid, // or null, or any other suitable value
          userName: data['userName'].toString(),
          userProfileImageUrl: data['userProfileImageUrl'].toString(),
          commentText: data['commentText'].toString(),
          timestamp: data['timestamp'],
        );
      }
    }).toList();

    if (mounted) {
      setState(() {
        comments = commentsList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const ContentText(text: 'نظریه ها'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.shade200,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(comment.userProfileImageUrl),
                        radius: 25,
                      ),
                      title: Text(comment.userName
                          .split('@')
                          .first), // Display the username
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ContentText(
                              size: 12.0,
                              color: Colors.black54,
                              text: LikeDislikeCounter.timeAgoFromTimestamp(
                                  comment.timestamp)),
                          ContentText(
                              size: 14.0,
                              color: Colors.black87,
                              text: comment.commentText),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        addCommentToFirebase(commentController.text);
                        commentController.clear();
                      } else {
                        setState(() {
                          isFilled = true;
                        });
                      }
                    },
                    icon: const Directionality(
                        textDirection: TextDirection.ltr,
                        child: Icon(Icons.send))),
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.yellowAccent)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      filled: true,
                      hintText: "نظریه ...",
                      fillColor: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addCommentToFirebase(String comment) {
    final timestamp = DateTime.now(); // Replace with your desired timestamp

    if (user != null) {
      _firestore.collection('comments').add({
        'productId': widget.productId,
        'commentText': comment,
        'userId': user!.uid, // Add user-related data
        'userName': user!.email, // Add user-related data
        'userProfileImageUrl': user!.photoURL, // Add user-related data
        'timestamp': timestamp,
      });
    }

    // After adding a comment, update the comments list
    _fetchComments();
  }
}

class Comment {
  final String commentText;
  final String userId; // Add user-related data
  final String userName; // Add user-related data
  final String userProfileImageUrl; // Add user-related data
  final Timestamp timestamp;

  Comment({
    required this.commentText,
    required this.userId,
    required this.userName,
    required this.userProfileImageUrl,
    required this.timestamp,
  });
}
