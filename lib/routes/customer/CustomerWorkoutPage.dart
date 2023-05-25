import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_methods.dart';
import '../models/AppBar.dart';
import '../models/RiverMenu.dart';

class CustomerWorkout extends StatefulWidget{
  const CustomerWorkout({super.key});

  @override
  CustomerWorkoutPage createState() => CustomerWorkoutPage();
}

class CustomerWorkoutPage extends State<CustomerWorkout> {
  String userName = "userName";
  String userRole = "customer";
  String customerWorkout = "";

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
      String workout = await authService.getWorkoutPlan(email);
      setState(() {
        userName = name;
      });
      return {
        'userName': name,
        'workoutPlan': workout,
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
        body: CustomScrollView(
          slivers: <Widget>[
            MyAppBar(userRole: userRole),
            const SliverFillRemaining(
              // child: WorkoutPlansDayWeek(categoryName: "One Week Workout",
              //   title: planName,
              //   icon: Icons.fitness_center,
              //   iconColor: primaryColor),
            )
          ],
        ),
      ),
    );
  }
}
