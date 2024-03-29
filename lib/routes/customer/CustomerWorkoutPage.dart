import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_methods.dart';
import '../../services/workout/OneWeekWorkoutServices.dart';
import '../../util/constants.dart';
import '../../util/showSnackBar.dart';
import '../chat/chatPage.dart';
import '../models/AppBar.dart';
import '../models/RiverMenu.dart';
import '../user/Workout/WorkoutPlansDayWeek.dart';

class CustomerWorkout extends StatefulWidget{
  const CustomerWorkout({super.key});

  @override
  CustomerWorkoutPage createState() => CustomerWorkoutPage();
}

class CustomerWorkoutPage extends State<CustomerWorkout> {
  String trainerID = "";
  String trainerEmail = "";
  String userName = "userName";
  String userRole = "customer";
  String customerWorkoutName = "";

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
      String workout = await authService.getWorkoutPlan(email);
      String workoutName = await getWorkoutPlanName(workout);
      setState(() {
        trainerID = trainer;
        trainerEmail = emailTrainer;
        userName = name;
        customerWorkoutName = workoutName;
      });
      return {
        'userName': name,
        'trainerID': trainer,
        'trainerEmail': emailTrainer,
        'workoutPlan': workout,
        'workoutPlanName': workoutName
      };
    }
    return {}; // Return an empty map if no user details are available
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: RiverMenu(
          userRole: userRole,
          userName: userName,
          selectedSection: "Workout",
        ),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                MyAppBar(userRole: userRole),
                SliverToBoxAdapter(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutPlansDayWeek(
                            userID: trainerID,
                            categoryName: "One Week Workout Plan",
                            title: customerWorkoutName,
                            icon: Icons.fitness_center,
                            iconColor: primaryColor,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(20),
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: lightLila,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        "Tap to see the workout days",
                        style: TextStyle(fontSize: 20, color: Colors.black87, fontFamily: font1),
                      ),
                    ),
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
                child: Icon(Icons.chat),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
