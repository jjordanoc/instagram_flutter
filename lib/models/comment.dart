import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String postId;
  final String text;
  final String uid;
  final String username;
  final String profilePictureUrl;
  final String commentId;
  final datePublished;

  const Comment({
    required this.postId,
    required this.text,
    required this.uid,
    required this.username,
    required this.profilePictureUrl,
    required this.commentId,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
    'postId' : postId,
    'text' : text,
    'uid' : uid,
    'username' : username,
    'profilePictureUrl' : profilePictureUrl,
    'commentId' : commentId,
    'datePublished' : datePublished,
  };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      postId: snapshot['postId'],
      text: snapshot['text'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      profilePictureUrl: snapshot['profilePictureUrl'],
      commentId: snapshot['commentId'],
      datePublished: snapshot['datePublished'],
    );
  }

}
