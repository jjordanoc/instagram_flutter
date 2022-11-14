import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final List followers;
  final List following;
  final String profilePictureUrl;

  const User({
    required this.uid,
    required this.username,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.profilePictureUrl,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'bio': bio,
        'followers': followers,
        'following': following,
        'profilePictureUrl': profilePictureUrl,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      uid: snapshot['uid'],
      username: snapshot['username'],
      email: snapshot['email'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      profilePictureUrl: snapshot['profilePictureUrl'],
    );
  }
}
