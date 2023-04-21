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
       throw Exception('User does not exist!');
     }
   }

  Future<String> getRole(String email) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User does not exist!');
    }

    DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
        .collection('trainers')
        .doc(user.uid)
        .get();

    DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection('customers')
        .doc(user.uid)
        .get();

    String role;
    if (adminSnapshot.exists) {
      // User exists in the "admins" table
      role = adminSnapshot.get('role');
    } else if (customerSnapshot.exists) {
      // User exists in the "customers" table
      role = customerSnapshot.get('role');
    } else {
      // User does not exist in either table
      throw Exception('User does not exist');
    }
    return role;
  }

  Future<String> getName(String email) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User does not exist!');
    }

    DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
        .collection('trainers')
        .doc(user.uid)
        .get();

    DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection('customers')
        .doc(user.uid)
        .get();

    String name;
    if (adminSnapshot.exists) {
      // User exists in the "admins" table
      name = adminSnapshot.get('name');
    } else if (customerSnapshot.exists) {
      // User exists in the "customers" table
      name = customerSnapshot.get('name');
    } else {
      // User does not exist in either table
      throw Exception('User does not exist');
    }
    return name;
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

  Future<String> getUserId() async {
    String? userID;
    final user = FirebaseAuth.instance.currentUser;
    userID = user!.uid;

    return userID;
  }
}

