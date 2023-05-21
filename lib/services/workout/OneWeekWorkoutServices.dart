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
      if( weekPlanName == ""  ) {
        throw Exception('Field cannot be empty.');
      }

      await firestore.collection("trainers")
          .doc(userID)
          .collection("workouts")
          .doc(workoutsCategory)
          .collection(workoutsCategory)
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

Future<List> getOneDayWorkoutsFromOneWeekPlan (String title, String userID) async {
  final firestore = FirebaseFirestore.instance;
  String collectionName = "One Week Workout Plan";
  List workouts = [];

  try{
    final querySnapshot = await firestore.collection("trainers/$userID/workouts/$collectionName/$collectionName").get();
    for (var docSnapshot in querySnapshot.docs) {
      if (docSnapshot.get('name') == title) {
        workouts.add(docSnapshot.get('monday'));
        workouts.add(docSnapshot.get('tuesday'));
        workouts.add(docSnapshot.get('wednesday'));
        workouts.add(docSnapshot.get('thursday'));
        workouts.add(docSnapshot.get('friday'));
        workouts.add(docSnapshot.get('saturday'));
        workouts.add(docSnapshot.get('sunday'));
        break;
      }
    }
  } catch (e) {
    Exception("Error completing: $e");
  }
  return workouts;
}

Future<DocumentReference<Map<String, dynamic>>> getOneWeekWorkoutPlanReference(String selectedWorkoutPlan, String trainerID) async{
  FirebaseFirestore db = FirebaseFirestore.instance;
  String oneWeekWorkoutPlanID = "";

  await db.collection("trainers/$trainerID/workouts/One Week Workout Plan/One Week Workout Plan").get().then(
        (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        if (docSnapshot.get('name') == selectedWorkoutPlan) {
          oneWeekWorkoutPlanID = docSnapshot.id;
          break;
        }
      }
    },
    onError: (e) => Exception("Error getting one week workout plan reference: $e"),
  );
  return db.doc("trainers/$trainerID/workouts/One Week Workout Plan/One Day Workout Plan/$oneWeekWorkoutPlanID");
}