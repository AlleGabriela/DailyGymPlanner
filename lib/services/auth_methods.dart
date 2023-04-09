import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../util/showSnackBar.dart';

class FirebaseAuthMethods {

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

    final CollectionReference customers = FirebaseFirestore.instance.collection('customers');
    final CollectionReference trainers = FirebaseFirestore.instance.collection('trainers');

    bool userExistsCustomer =
        (await customers.where('email', isEqualTo: email).get()).docs.isNotEmpty;
    bool userExistsTrainer =
        (await trainers.where('email', isEqualTo: email).get()).docs.isNotEmpty;

    if (userExistsCustomer) {
      // User already exists! Handle it here
      showSnackBar(context, 'User already exists based on this e-mail address');
    } else if(userExistsTrainer) {
      // User already exists! Handle it here
      showSnackBar(context, 'User already exists based on this e-mail address');
    } else {
      // User does not exist. Proceed with sign up
      CollectionReference collection;
      try {
        if (password != confirmpassword) {
          throw Exception('Passwords do not match.');
        }
        if (role == 'Trainer') {
          collection = FirebaseFirestore.instance.collection('trainers');
        } else if (role == 'Customer') {
          collection = FirebaseFirestore.instance.collection('customers');
        } else {
          throw Exception('Invalid role');
        }
        if( email == "" || name == "" || password == "") {
          throw Exception('Field cannot be empty.');
        }
        await collection.add({
          'name': name,
          'email': email,
          'password': password
        });
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

     final CollectionReference customers = FirebaseFirestore.instance
         .collection('customers');
     final CollectionReference trainers = FirebaseFirestore.instance.collection(
         'trainers');

     bool userExistsCustomer =
         (await customers.where('email', isEqualTo: email).get()).docs
             .isNotEmpty;
     bool userExistsTrainer =
         (await trainers.where('email', isEqualTo: email).get()).docs
             .isNotEmpty;

     bool userPasswordCustomer =
         (await trainers.where('password', isEqualTo: password).get()).docs
             .isNotEmpty;

     bool userPasswordTrainer =
         (await trainers.where('password', isEqualTo: password).get()).docs
             .isNotEmpty;

     if (userExistsCustomer) {
       if (userPasswordCustomer) {
         //TODO: add redirection to CUSTOMER PAGE
         //TODO HINT: look in sign_up page, there is a model
         } else {
         showSnackBar(context, 'Wrong password provided!');
       }
     } else if (userExistsTrainer) {
       if (userPasswordTrainer) {
         //TODO: add redirection to ADMIN PAGE
         //TODO HINT: look in sign_up page, there is a model
       } else {
         showSnackBar(context, 'Wrong password provided!');
       }
     } else {
       try {
         if (userExistsCustomer == false || userExistsTrainer == false) {
           showSnackBar(context, 'No user found!');
         } else {
           showSnackBar(context, 'Please fill all the cells!');
         }
       } catch (e) {
         showSnackBar(context, 'Failed to login user!');
       }
     }
   }
}

