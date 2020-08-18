import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Stream<FirebaseUser> user;
  Stream<Map<String, dynamic>> profile;

  Authentication() {
    user = _auth.onAuthStateChanged;
    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Stream.empty();
      }
    });
  }

  void saveUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    try {
      return ref.setData({
        'uid': user.uid,
        'email': user.email,
        'photoURL': user.photoUrl,
        'displayName': user.displayName,
      }, merge: true);
    }
    catch(e) {
      e.message();
    }
  }

  void signOut() {
    _auth.signOut();
  }

  Future<FirebaseUser> signIn(GlobalKey<FormState> formKey, String email, String password) async {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();

      try {
        AuthResult auth = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        FirebaseUser user = auth.user;
        return user;
      }
      catch (e) {
        print(e);
        return null;
      }
    }
    else {
      return null;
    }
  }

  Future<FirebaseUser> register(GlobalKey<FormState> formKey, String displayName,
      String email, String password) async {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();

      try {
        AuthResult result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        FirebaseUser user = result.user;

        UserUpdateInfo info = UserUpdateInfo();
        info.displayName = displayName;

        await user.updateProfile(info);
        await user.reload();
        user = await _auth.currentUser();

        saveUserData(user);

        return user;
      } catch (e) {
        e.message();

        return null;
      }
    }
    else {
      return null;
    }
  }
}

final Authentication anthentication = Authentication();