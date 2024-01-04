import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_methods.dart';
import '../../util/constants.dart';
import '../../util/showSnackBar.dart';
import '../chat/chatPage.dart';
import '../models/AppBar.dart';
import '../models/RiverMenu.dart';

import '../../../services/feedback/FeedbackServices.dart';
import 'CustomerHomePage.dart';

class CustomerFeedback extends StatefulWidget{
  const CustomerFeedback({super.key});

  @override
  CustomerFeedbackPage createState() => CustomerFeedbackPage();
}

class CustomerFeedbackPage extends State<CustomerFeedback> {
  String trainerID = "";
  String trainerEmail = "";
  String userName = "userName";
  String userRole = "customer";
  bool workoutHardness = false; // Yes/No for hardness question
  bool painDuringPlan = false; // Yes/No for pain question
  bool challengedByPlan = false; // Yes/No for challenge question
  bool changePlan = false; // Yes/No for changePlan question
  String additionalFeedback = ''; // Text for additional feedback

  late Future<Map<String, String>> fetchDetails;

  @override
  void initState() {
    super.initState();
    fetchDetails = _getUserDetails();
  }

  Future<Map<String, String>> _getUserDetails() async {
    FirebaseAuthMethods authService = FirebaseAuthMethods();
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    if (email != null) {
      String name = await authService.getName(email);
      String trainer = await authService.getTrainer(email);
      String emailTrainer = await authService.getTrainerDetails(trainer, "email");
      setState(() {
        trainerID = trainer;
        userName = name;
        trainerEmail = emailTrainer;
      });
      return {
        'userName': name,
        'trainerID': trainer,
        'trainerEmail': emailTrainer
      };
    }
    return {}; // Return an empty map if no user details are available
  }

  void submitForm() async {
    final feedback = myFeedback(
      workoutHardness,
      painDuringPlan,
      challengedByPlan,
      changePlan,
      additionalFeedback
    );

    try{
      await feedback.addFeedback();
      showSnackBar(context, "Feedback added successfully!");
      Navigator.pop(context);
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const CustomerHome(),
        ),
      );
    } catch (e) {
      throw Exception('Error adding feedback to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: RiverMenu(
          userRole: userRole,
          userName: userName,
          selectedSection: "Give Feedback",
        ),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                MyAppBar(userRole: userRole),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildYesNoQuestion('Was the workout too hard?', workoutHardness, (value) {
                              setState(() {
                                workoutHardness = value;
                              });
                            }),
                            _buildYesNoQuestion('Did anything hurt during your plan?', painDuringPlan, (value) {
                              setState(() {
                                painDuringPlan = value;
                              });
                            }),
                            _buildYesNoQuestion('Were you challenged by this plan?', challengedByPlan, (value) {
                              setState(() {
                                challengedByPlan = value;
                              });
                            }),
                            _buildYesNoQuestion('Do you want a change in this workout plan?', changePlan, (value) {
                              setState(() {
                                changePlan = value;
                              });
                            }),
                            _buildTextQuestion('Do you want to say something?', additionalFeedback, (value) {
                              setState(() {
                                additionalFeedback = value;
                              });
                            }),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: inputDecorationColor, // Background color
                              ),
                              child: const Text(
                                'Submit Feedback',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Chat icon positioned in the bottom-right corner
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  if(trainerEmail != null && trainerID != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(receiverUserEmail: trainerEmail, receiverUserID: trainerID),
                      ),
                    );
                  } else {
                    showSnackBar(context, "This feature will be available when you will have a trainer.");
                  }
                },
                backgroundColor: lightLila,
                child: const Icon(Icons.chat),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildYesNoQuestion(String question, bool value, Function(bool) onChanged) {
  return SwitchListTile(
    title: Text(question),
    subtitle: Text(value ? 'Yes' : 'No'), // Use subtitle to display Yes or No based on the value
    value: value,
    onChanged: onChanged,
  );
}

Widget _buildTextQuestion(String question, String value, Function(String) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        question,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: 'Enter your feedback here',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}
