import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../services/ClientServices.dart';
import '../../../services/auth_methods.dart';
import '../../../util/constants.dart';
import 'FeedbackPage.dart';

class ClientFeedbackPage extends StatefulWidget {
  final dynamic clientEmail;
  final dynamic clientID;

  const ClientFeedbackPage({Key? key, this.clientEmail, this.clientID}) : super(key: key);

  @override
  State<ClientFeedbackPage> createState() => _ClientFeedbackPageState();
}

class _ClientFeedbackPageState extends State<ClientFeedbackPage> {

  FirebaseAuthMethods authMethods = FirebaseAuthMethods();
  FirebaseFirestore db = FirebaseFirestore.instance;

  String userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: addPagesBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.clientEmail,
              style: TextStyle(fontSize: 16, color: accentColor),
            ),
            Text(
              "Feedback",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column (
            children: [
              const SizedBox(height: 32),
              // Question 1: Was the workout too hard?
              FutureBuilder<String>(
                future: getWorkoutFeedback("hardness", widget.clientID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show a loading indicator while data is being fetched
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    String workoutHardness = snapshot.data ?? 'Not answered';
                    return section("Was the workout too hard?", workoutHardness, [], Icons.star);
                  }
                },
              ),

              // Question 2: Did anything hurt during your plan?
              FutureBuilder<String>(
                future: getWorkoutFeedback("hurt", widget.clientID), // Replace with the actual function to get the workout hurt status from the database
                builder: (context, snapshot) {
                  String hurtStatus = snapshot.data ?? 'Not answered';
                  return section("Did anything hurt during your plan?", hurtStatus, [], Icons.warning);
                },
              ),

              // Question 3: Were you challenged by this plan?
              FutureBuilder<String>(
                future: getWorkoutFeedback("challenged", widget.clientID), // Replace with the actual function to get the workout challenged status from the database
                builder: (context, snapshot) {
                  String challengedStatus = snapshot.data ?? 'Not answered';
                  return section("Were you challenged by this plan?", challengedStatus, [], Icons.access_alarm);
                },
              ),

              // Question 4: Do you want a change in this workout plan?
              FutureBuilder<String>(
                future: getWorkoutFeedback("change", widget.clientID), // Replace with the actual function to get the workout change status from the database
                builder: (context, snapshot) {
                  String changeStatus = snapshot.data ?? 'Not answered';
                  return section("Do you want a change in this workout plan?", changeStatus, [], Icons.edit);
                },
              ),

              // Question 5: Do you want to say something?
              FutureBuilder<String>(
                future: getWorkoutFeedback("comments", widget.clientID), // Replace with the actual function to get the workout comments from the database
                builder: (context, snapshot) {
                  String comments = snapshot.data ?? 'Not answered';
                  return section("Do you want to say something?", comments, [], Icons.comment);
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

    );
  }
}

Widget section(String question, String answer, List<String> options, IconData icon) {
  return Column(
    children: [
      Text(
        question,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      answer.isNotEmpty
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      )
          : Text(
        'Not answered',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
      SizedBox(height: 10),
      Icon(
        icon,
        size: 30,
        color: lightLila, // Change the color as needed
      ),
      SizedBox(height: 20),
    ],
  );
}

