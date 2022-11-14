import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String profileImageUrl;
  final String postImageUrl;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.profileImageUrl,
    required this.datePublished,
    required this.postImageUrl,
    required this.likes,
  });

  Map<String, dynamic> toJson() =>
      {
        'description': description,
        'uid': uid,
        'username': username,
        'postId': postId,
        'profileImageUrl': profileImageUrl,
        'datePublished': datePublished,
        'postImageUrl': postImageUrl,
        'likes': likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postImageUrl: snapshot['postImageUrl'],
      postId: snapshot['postId'],
      profileImageUrl: snapshot['profileImageUrl'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
    );
  }
}
