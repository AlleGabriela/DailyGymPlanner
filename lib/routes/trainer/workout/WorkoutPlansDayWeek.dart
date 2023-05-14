import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:flutter/material.dart';
import '../../../services/workout/OneDayWorkoutServices.dart';
import '../../../services/workout/OneWeekWorkoutServices.dart';
import '../../../util/constants.dart';
import '../../models/ListItems.dart';

class WorkoutPlansDayWeek extends StatefulWidget{
  final String categoryName;
  final String title;
  final IconData icon;
  final Color iconColor;
  const WorkoutPlansDayWeek({super.key, required this.categoryName, required this.title, required this.icon, required this.iconColor});

  @override
  WorkoutPlansDayWeekPage createState() => WorkoutPlansDayWeekPage(categoryName, title, icon, iconColor);
}

class WorkoutPlansDayWeekPage extends State<WorkoutPlansDayWeek>{
  String userName = "userName";
  String categoryName = "";
  String title = "";
  IconData icon;
  Color iconColor;

  List workouts = [];
  List<Widget> fullWorkout = [];

  WorkoutPlansDayWeekPage(this.categoryName, this.title, this.icon, this.iconColor);

  @override
  void initState() {
    super.initState();
    handleUserID();
  }

  void handleUserID() async {
    FirebaseAuthMethods authMethods = FirebaseAuthMethods();
    String userId = await authMethods.getUserId();
    chooseSubcategory(userId);
    if( fullWorkout == []) {
      throw Exception("The list is still empty!");
    }
  }

  void chooseSubcategory(String userId) async{
    if( categoryName == "One Day Workout") {
      workouts = await getMuscleGroupsFromOneDayWorkout(title, userId);
      if (workouts.isNotEmpty) {
        fullWorkout = [for (final workout in workouts) await buildWorkoutContainer(workout)];
      }
    }
    else if( categoryName == "One Week Workout Plan") {
      List imageList = ["assets/images/monday.jpg"] + ["assets/images/tuesday.jpg"] + ["assets/images/wednesday.jpg"] + ["assets/images/thursday.jpg"] + ["assets/images/friday.jpg"] + ["assets/images/saturday.jpg"] + ["assets/images/sunday.jpg"];
      workouts = await getOneDayWorkoutsFromOneWeekPlan(title, userId);
      if (workouts.isNotEmpty) {
        int index = 0;
        fullWorkout = [for (final workout in workouts) await buildPlanContainer(workout, imageList, index++)];
      }
    }
    setState(() {});
  }

  Future<Container> buildWorkoutContainer(doc) async {
    String workoutName = '';
    List workoutExercise = [];
    String workoutID = '';
    IconData? workoutIcon = Icons.fitness_center;
    Color? workoutIconColor = primaryColor;

    try {
      await FirebaseFirestore.instance.doc(doc).get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        workoutName = data['name'];
        workoutExercise = data['workoutExercise'];
        workoutID = doc.id;
      });
    } catch (e) {
      Exception("Error accessing the exercise group: $e");
    }
    return Container(
      margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
      height: 80,
      child: GestureDetector(
        onTap: () {
          // TODO: Handle the container's tap event
        },
        child: listItemsWithoutImage(workoutName, workoutIcon, workoutIconColor),
      ),
    );
  }

  Future<Container> buildPlanContainer(doc, List imageList, int index) async{
    String planName = "";
    IconData? workoutIcon = Icons.fitness_center;
    Color? workoutIconColor = primaryColor;

    if( doc == "Rest Day") {
      return Container(
        margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
        height: 180,
        child: listItemsUsingImageAsset("", "assets/images/restDay.jpg", workoutIcon, workoutIconColor),
      );
    } else {
      try {
        await FirebaseFirestore.instance.doc(doc).get().then((
            DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          planName = data['name'];
        });
      } catch (e) {
        Exception("Error accessing the plan workout: $e");
      }
      return Container(
          margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
          height: 180,
          child: GestureDetector(
            onTap: () {
              // TODO: ADD ACTION!
            },
            child: listItemsUsingImageAsset(planName, imageList[index], workoutIcon, workoutIconColor),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text(title),
            backgroundColor: primaryColor,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon:const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                fullWorkout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}