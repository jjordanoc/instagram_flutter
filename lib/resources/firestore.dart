import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/comment.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/resources/storage.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    User user,
  ) async {
    String res = "Success";
    try {
      // Upload image to storage
      String postImageUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      // Create post object
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: user.uid,
        postId: postId,
        datePublished: DateTime.now(),
        postImageUrl: postImageUrl,
        profileImageUrl: user.profilePictureUrl,
        username: user.username,
        likes: [],
      );
      // Upload post to firestore
      _firestore.collection('posts').doc(postId).set(post.toJson());
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(
    String postId,
    String uid,
    List likes,
  ) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {}
  }

  Future<String> postComment(
    String postId,
    String text,
    User user,
  ) async {
    String res = 'Success';
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        Comment comment = Comment(
          postId: postId,
          text: text,
          uid: user.uid,
          username: user.username,
          profilePictureUrl: user.profilePictureUrl,
          commentId: commentId,
          datePublished: DateTime.now(),
        );
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(comment.toJson());
      } else {
        res = 'Text is empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deletePost(
    String postId,
  ) async {
    String res = 'Success';
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> followUser(
    String uid,
    String otherId,
  ) async {
    String res = 'Success';
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = snap['following'];
      if (following.contains(otherId)) {
        await _firestore.collection('users').doc(otherId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([otherId]),
        });
      } else {
        await _firestore.collection('users').doc(otherId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([otherId]),
        });
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
