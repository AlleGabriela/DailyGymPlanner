import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../util/showSnackBar.dart';

class FirebaseAuthMethods {

  Future<bool> doesUserExist(String email) async {
    if (await doesCustomerExist(email)) {
      return true;
    } else {
      return await doesTrainerExist(email);
    }
  }

  Future<bool> doesCustomerExist(String email) async {
    final customers = FirebaseFirestore.instance.collection('customers');
    final userSnapshot = await customers.where('email', isEqualTo: email).get();
    return userSnapshot.docs.isNotEmpty;
  }

  Future<bool> doesTrainerExist(String email) async {
    final trainers = FirebaseFirestore.instance.collection('trainers');
    final userSnapshot = await trainers.where('email', isEqualTo: email).get();
    return userSnapshot.docs.isNotEmpty;
  }

  Future<String> getCustomerID(String email) async {
    String customerID = "";
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection("customers").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.get('email') == email) {
            customerID = docSnapshot.id;
            break;
          }
        }
      },
      onError: (e) => Exception("Error getting customer id: $e"),
    );
    return customerID;
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
      showSnackBar(context, 'An user with same email already exists!');
    } else {
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
        if (email == "" || name == "" || password == "") {
          throw Exception('Field cannot be empty.');
        }
        final credentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (collection == 'customers') {
          FirebaseFirestore.instance
              .collection(collection)
              .doc(credentials.user?.uid)
              .set({
            'name': name,
            'role': role,
            'photo': '',
            'location': 'The location is not set yet',
            'trainer': '',
            'workoutPlan': '',
            'mealPlan': '',
            'email': email
          });
        } else {
          FirebaseFirestore.instance
              .collection(collection)
              .doc(credentials.user?.uid)
              .set({
            'name': name,
            'role': role,
            'photo': '',
            'location': 'The location is not set yet',
            'email': email
          });
        }
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
    if (await doesCustomerExist(email)) {
      return "Customer";
    } else if (await doesTrainerExist(email)) {
      return "Trainer";
    } else {
      return "None";
    }
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

  Future<String> getLocation(String email) async {
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

    String location;
    if (adminSnapshot.exists) {
      // User exists in the "admins" table
      location = adminSnapshot.get('location');
    } else if (customerSnapshot.exists) {
      // User exists in the "customers" table
      location = customerSnapshot.get('location');
    } else {
      // User does not exist in either table
      throw Exception('User does not exist');
    }
    return location;
  }

  Future<String> getPhoto(String email) async {
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

    String photo;
    if (adminSnapshot.exists) {
      // User exists in the "admins" table
      photo = adminSnapshot.get('photo');
    } else if (customerSnapshot.exists) {
      // User exists in the "customers" table
      photo = customerSnapshot.get('photo');
    } else {
      // User does not exist in either table
      throw Exception('User does not exist');
    }
    return photo;
  }

  Future<String> getWorkoutPlan(String email) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User does not exist!');
    }
    DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection('customers')
        .doc(user.uid)
        .get();

    String plan;
    if (customerSnapshot.exists) {
      plan = customerSnapshot.get('workoutPlan');
    } else {
      throw Exception('User does not exist');
    }
    return plan;
  }

  Future<String> getTrainer(String email) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User does not exist!');
    }
    DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection('customers')
        .doc(user.uid)
        .get();

    String trainer;
    if (customerSnapshot.exists) {
      // User exists in the "customers" table
      trainer = customerSnapshot.get('trainer');
    } else {
      // User does not exist in either table
      throw Exception('User does not exist');
    }
    return trainer;
  }

  Future<String> getTrainerDetails(String id, String infoType) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User does not exist!');
    }
    DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
        .collection('trainers')
        .doc(id)
        .get();

    String info;
    if (adminSnapshot.exists) {
      info = adminSnapshot.get(infoType);
    } else {
      throw Exception('User does not exist');
    }
    return info;
  }

  Future<void> handlePassReset({
    required String email,
    required BuildContext context,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    try {
      List<String> userSignInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email);

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

  Future<void> updatePhotoURL(String collection, String userId, String newPhotoURL) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference docRef = firestore.collection(collection).doc(userId);
    try {
      await docRef.update({
        'photo': newPhotoURL,
      });
    } catch (error) {
      Exception('Error updating photo URL: $error');
    }
  }

  Future<void> updateUsername(String collection, String userId, String newUsername) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference docRef = firestore.collection(collection).doc(userId);
    try {
      await docRef.update({
        'name': newUsername,
      });
    } catch (e) {
      Exception('Error updating username: $e');
    }
  }

  Future<void> updateLocation(String collection, String userId, String newLocation) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference docRef = firestore.collection(collection).doc(userId);
    try {
      await docRef.update({
        'location': newLocation,
      });
    } catch (e) {
      Exception('Error updating location: $e');
    }
  }

}

