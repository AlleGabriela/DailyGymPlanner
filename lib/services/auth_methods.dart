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
          .set({'name': name});
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
}

