import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../services/workout/OneDayWorkoutServices.dart';
import '../../../services/workout/OneWeekWorkoutServices.dart';
import '../../../util/constants.dart';
import '../../models/ListItems.dart';
import 'GroupExerciseDetails.dart';

class WorkoutPlansDayWeek extends StatefulWidget{
  final String userID;
  final String categoryName;
  final String title;
  final IconData icon;
  final Color iconColor;
  const WorkoutPlansDayWeek({super.key, required this.userID, required this.categoryName, required this.title, required this.icon, required this.iconColor});

  @override
  WorkoutPlansDayWeekPage createState() => WorkoutPlansDayWeekPage();
}

class WorkoutPlansDayWeekPage extends State<WorkoutPlansDayWeek>{
  String userName = "userName";
  String currentUserID = "";

  List workouts = [];
  List<Widget> fullWorkout = [];

  @override
  void initState() {
    super.initState();
    chooseSubcategory();
    if( fullWorkout == []) {
      throw Exception("The list is still empty!");
    }
  }

  void chooseSubcategory() async{
    if( widget.categoryName == "One Day Workout") {
      workouts = await getMuscleGroupsFromOneDayWorkout(widget.title, widget.userID);
      if (workouts.isNotEmpty) {
        fullWorkout = [for (final workout in workouts) await buildWorkoutContainer(workout)];
      }
    }
    else if( widget.categoryName == "One Week Workout Plan") {
      List imageList = ["assets/images/monday.jpg"] + ["assets/images/tuesday.jpg"] + ["assets/images/wednesday.jpg"] + ["assets/images/thursday.jpg"] + ["assets/images/friday.jpg"] + ["assets/images/saturday.jpg"] + ["assets/images/sunday.jpg"];
      workouts = await getOneDayWorkoutsFromOneWeekPlan(widget.title, widget.userID);
      if (workouts.isNotEmpty) {
        int index = 0;
        fullWorkout = [for (final workout in workouts) await buildPlanContainer(workout, imageList, index++)];
      }
    }
    setState(() {});
  }

  String searchSubcategory(String category, String searchedString) {
    if(searchedString.contains("Upper Body")) {
      if(searchedString.contains("Abs")) {
        return "Abs";
      } else if(searchedString.contains("Back")) {
        return "Back";
      } else if(searchedString.contains("Biceps")) {
        return "Biceps";
      } else if(searchedString.contains("Chest")) {
        return "Chest";
      } else if(searchedString.contains("Shoulders")) {
        return "Shoulders";
      } else if(searchedString.contains("Traps")) {
        return "Traps";
      } else if(searchedString.contains("Triceps")) {
        return "Triceps";
      }
    } else if( searchedString.contains("Lower Body")) {
      if(searchedString.contains("Calves")) {
        return "Calves";
      } else if(searchedString.contains("Glutes")) {
        return "Glutes";
      } else if(searchedString.contains("Hamstrings")) {
        return "Hamstrings";
      } else if(searchedString.contains("Quads")) {
        return "Quads";
      }
    }
    return "";
  }

  String searchCategory(String category, String searchedString) {
    if(searchedString.contains("Upper Body")) {
      return "Upper Body";
    } else if(searchedString.contains("Lower Body")) {
      return "Lower Body";
    }
    return "";
  }

  Future<Container> buildWorkoutContainer(doc) async {
    String workoutName = '';
    IconData? workoutIcon = Icons.fitness_center;
    Color? workoutIconColor = primaryColor;

    try {
      await FirebaseFirestore.instance.doc(doc).get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        workoutName = data['name'];
      });
    } catch (e) {
      Exception("Error accessing the exercise group: $e");
    }
    return Container(
      margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
      height: 80,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupExerciseDetails(
                userID: widget.userID,
                  categoryName: searchCategory(widget.categoryName, doc),
                  subcategoryName: searchSubcategory(widget.categoryName, doc),
                  title: workoutName
              ),
            ),
          );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutPlansDayWeek(
                    userID: widget.userID,
                    categoryName: "One Day Workout",
                    title: planName,
                    icon: Icons.fitness_center,
                    iconColor: primaryColor,
                  ),
                ),
              );
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
            title: Text(widget.title),
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