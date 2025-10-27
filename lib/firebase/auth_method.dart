import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/model/user.dart' as model;
import 'package:twitch_clone/provider/user_provider.dart';

import 'package:twitch_clone/utils/utils.dart';

class AuthMethod {
  final userRef = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getCurrentUser(BuildContext context) async {
    
    if (auth.currentUser != null) {
      final current = await userRef.doc(auth.currentUser!.uid).get();
      var userData = model.User.fromJson(current.data()!);
       
      Provider.of<UserProvider>(context,listen: false).setUser(userData);
      return userData.toJson();
    }
    return null;
  }

  Future<bool> signUpUser(
    String email,
    String password,
    String username,
    BuildContext context,
  ) async {
    bool res = false;
    try {
      final created = DateTime.now();
      final time = "${created.day}/${created.month}/${created.year}";
      final newUser = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      model.User user = model.User(
        uuid: newUser.user!.uid,
        email: email,
        username: username,
        createdAt: time,
      );
      await userRef.doc(newUser.user!.uid).set(user.toJson());
      Provider.of<UserProvider>(context, listen: false).setUser(user);

      res = true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return res;
  }

  Future<bool> logInUser({
    required String email,
    required String password,

    required BuildContext context,
  }) async {
    bool res = false;
    try {
      final loggedUser = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final data = await userRef.doc(loggedUser.user!.uid).get();
      final userData = model.User.fromJson(data.data()!);

      Provider.of<UserProvider>(context, listen: false).setUser(userData);

      res = true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return res;
  }
  Future<void> logOut()async{
    await auth.signOut();
     
  }
}
