import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/services/workout/OneDayWorkoutServices.dart';

import '../auth_methods.dart';


class OneWeekWorkoutPlan {
  String userID;
  String weekPlanName;
  String monday;
  String tuesday;
  String wednesday;
  String thursday;
  String friday;
  String saturday;
  String sunday;

  OneWeekWorkoutPlan(this.userID, this.weekPlanName, this.monday, this.tuesday, this.wednesday, this.thursday, this.friday, this.saturday, this.sunday);

  Future<void> addOneWeekWorkoutToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    String workoutsCategory = "One Week Workout Plan";

    try {
      final meals = firestore.collection("trainers").doc(userID).collection("workouts");
      meals.doc(workoutsCategory).set({});

      await firestore.collection("trainers")
          .doc(userID)
          .collection("workouts")
          .doc(workoutsCategory)
          .collection("One Week Workout Plan")
          .add({'name': weekPlanName,
        'monday':await getOneDayWorkoutReference(monday),
        'tuesday': await getOneDayWorkoutReference(tuesday),
        'wednesday': await getOneDayWorkoutReference(wednesday),
        'thursday': await getOneDayWorkoutReference(thursday),
        'friday': await getOneDayWorkoutReference(friday),
        'saturday': await getOneDayWorkoutReference(saturday),
        'sunday': await getOneDayWorkoutReference(sunday),
        'createdAt': DateTime.now().toUtc()});

    } catch (e) {
      throw Exception('One Week Meal Plan cannot be added to firebase: $e');
    }
  }
}

Future<List<String>> getOneWeekWorkoutsName(String collectionName) async {
  String userID = await FirebaseAuthMethods().getUserId();
  final firestore = FirebaseFirestore.instance;
  List<String> oneWeekWorkoutsNames = [];

  try {
    final querySnapshot = await firestore.collection("trainers/$userID/workouts/$collectionName/$collectionName").get();
    for (var docSnapshot in querySnapshot.docs) {
      oneWeekWorkoutsNames.add(docSnapshot.get('name'));
    }
  } catch (e) {
    Exception("Error completing: $e");
  }
  return oneWeekWorkoutsNames;
}