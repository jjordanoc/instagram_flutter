import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/resources/storage.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snapshot);
  }

  // Sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Success";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        // Register user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // Add image to storage
        String profilePictureUrl = await StorageMethods()
            .uploadImageToStorage('profilePictures', file, false);
        // Add user to our database
        model.User user = model.User(
          uid: credential.user!.uid,
          username: username,
          email: email,
          bio: '',
          followers: [],
          following: [],
          profilePictureUrl: profilePictureUrl,
        );
        _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());
      } else {
        res = "Please enter all the required fields.";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        res = 'The email address is already in use by another account.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Log in user
  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "Success";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        res = "Please enter all the required fields.";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'User not found.';
      } else if (e.code == 'wrong-password') {
        res = 'Incorrect password.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
