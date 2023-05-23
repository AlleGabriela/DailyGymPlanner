import 'package:daily_gym_planner/routes/models/AppBar.dart';
import 'package:daily_gym_planner/routes/models/ListItems.dart';
import 'package:daily_gym_planner/routes/models/RiverMenu.dart';
import 'package:daily_gym_planner/routes/trainer/Workout/AddWorkout.dart';
import 'package:daily_gym_planner/routes/trainer/Workout/CategoryPage.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../util/constants.dart';

import '../../models/category.dart';

class WorkoutList extends StatefulWidget{
  const WorkoutList({super.key});

  @override
  WorkoutListPage createState() => WorkoutListPage();
}

class WorkoutListPage extends State<WorkoutList>{
  String userName = "userName";
  String userRole = "trainer";
  final List<Category> categories = [
    Category(
        color: primaryColor,
        name: "Upper Body Workouts",
        icon: Icons.fitness_center,
        imgName: 'assets/images/UpperBodyWorkout.jpg'
    ),
    Category(
        color: primaryColor,
        name: "Lower Body Workouts",
        icon: Icons.fitness_center,
        imgName: 'assets/images/LowerBodyWorkout.jpg'
    ),
    Category(
        color: primaryColor,
        name: "One Day Workout",
        icon: Icons.fitness_center,
        imgName:  'assets/images/OneDayWorkout.jpg'
    ),
    Category(
        color: primaryColor,
        name: "One Week Workout Plan",
        icon: Icons.fitness_center,
        imgName: 'assets/images/OneWeekWorkout.jpg'
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    FirebaseAuthMethods _authService = FirebaseAuthMethods();
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    if (email != null) {
      String name = await _authService.getName(email) ;
      setState(() {
        userName = name;
      });
    }
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
            const MyAppBar(),
            SliverFillRemaining(
              child: Container(
                color: accentColor,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        color: lightLila,
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "\nWant to add a new workout? ",
                                  style: const TextStyle(
                                    color: buttonTextColor,
                                    fontSize: questionSize,
                                    fontFamily: font2,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddWorkoutPage(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              return Container(
                                  margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
                                  height: itemListHeight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CategoryList(categoryName: categories[index].name, icon: categories[index].icon, iconColor: categories[index].color),
                                        ),
                                      );
                                    },
                                    child: listItemsUsingImageAsset(categories[index].name, categories[index].imgName, categories[index].icon, categories[index].color),
                                  )
                              );
                            },
                          )
                      )
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}