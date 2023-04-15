import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../util/showSnackBar.dart';

class FirebaseAuthMethods {

  Future<bool> doesUserExist(String email) async {
    final users = FirebaseFirestore.instance.collection('users');
    final userSnapshot = await users.where('email', isEqualTo: email).get();
    return userSnapshot.docs.isNotEmpty;
  }

  Future<void> handleSignUp({
    required String role,
    required String name,
    required String email,
    required String password,
    required String confirmpassword,
    required BuildContext context,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    if (await doesUserExist(email)) {
      // User already exists ERROR!
      }  else {
      // User does not exist. Proceed with sign up
      String collection;
      try {
        if (password != confirmpassword) {
          throw Exception('Passwords do not match.');
        }
        if (role == 'Trainer') {
          collection = "trainers";
        } else if (role == 'Customer') {
          collection = 'customers';
        } else {
          throw Exception('Invalid role');
        }
        if( email == "" || name == "" || password == "") {
          throw Exception('Field cannot be empty.');
        }
        final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword( email: email, password: password);
        FirebaseFirestore.instance
          .collection(collection)
          .doc(credentials.user?.uid)
          .set({'name': name, 'role': role});
      } catch (e) {
        showSnackBar(context, 'Failed to create user: $e');
      }
    }
  }

   Future<void> handleLogIn({
    required String email,
    required String password,
     required BuildContext context,
   }) async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();

     try {
       await FirebaseAuth.instance.signInWithEmailAndPassword(
           email: email,
           password: password
       );
     } on FirebaseAuthException catch (e) {
       showSnackBar(context, e.message!);
     }
   }

  Future<String> getRole(String userId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    String role = snapshot.get('role');
    return role;
  }

  Future<void> handlePassReset({
    required String email,
    required BuildContext context,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    try {
      List<String> userSignInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (userSignInMethods.isNotEmpty) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showSnackBar(context, 'Password Reset Email Sent');
      } else {
        showSnackBar(context, 'Email is not valid');
      }

    } on FirebaseAuthException catch (e) {
        print(e);
        showSnackBar(context, e.message!);
    }
  }
}

