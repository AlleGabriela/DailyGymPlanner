import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth_methods.dart';

class OneDayWorkoutExercise {
  String bodyPart;
  String muscleGroup;
  String muscleGroupPlan;

  OneDayWorkoutExercise(this.bodyPart, this.muscleGroup, this.muscleGroupPlan);
}

class OneDayWorkout {
  String userID;
  String name;
  List oneDayWorkoutExercise;

  OneDayWorkout(this.userID, this.name, this.oneDayWorkoutExercise);

  Future<void> addOneDayWorkoutToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    try {
      if( name == ""  ) {
        throw Exception('Field cannot be empty.');
      }

      await firestore.collection("trainers")
          .doc(userID)
          .collection("workouts")
          .doc("One Day Workouts")
          .collection("All One Day Workouts")
          .add({'name': name,
                'groupOfWorkouts': oneDayWorkoutExercise,
                'createdAt': DateTime.now().toUtc(),});
    } catch (e) {
      throw Exception('Muscle Group Exercise cannot be added to firebase.');
    }
  }
}

Future<String> getOneDayWorkoutReference(String selectedDay) async {
  String userID = await FirebaseAuthMethods().getUserId();
  String oneDayWorkoutGroupID = "";
  final firestore = FirebaseFirestore.instance;
  String collectionName = "One Day Workouts";
  String subcollectionName = "All One Day Workouts";

  try {
    await firestore.collection("trainers/$userID/workouts/$collectionName/$subcollectionName").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.get('name') == selectedDay) {
            oneDayWorkoutGroupID = docSnapshot.id;
            break;
          }
        }
      },
    );
  } catch (e) {
    Exception("Error completing: $e");
  }
  if (oneDayWorkoutGroupID != "") {
    return firestore.doc("trainers/$userID/workouts/$collectionName/$subcollectionName/$oneDayWorkoutGroupID").path;
  } else {
    return "Rest Day";
  }
}

Future<List<String>> getOneDayWorkoutsName(String collectionName, String subcollectionName) async {
  String userID = await FirebaseAuthMethods().getUserId();
  final firestore = FirebaseFirestore.instance;
  List<String> oneDayWorkoutsNames = [];

  try {
    final querySnapshot = await firestore.collection("trainers/$userID/workouts/$collectionName/$subcollectionName").get();
    for (var docSnapshot in querySnapshot.docs) {
      oneDayWorkoutsNames.add(docSnapshot.get('name'));
    }
  } catch (e) {
    Exception("Error completing: $e");
  }
  return oneDayWorkoutsNames;
}

Future<List> getMuscleGroupsFromOneDayWorkout (String title, String userID) async {
  final firestore = FirebaseFirestore.instance;
  List workouts = [];
  String collectionName = "One Day Workouts";
  String subcollectionName = "All One Day Workouts";

  try {
    final querySnapshot = await firestore.collection("trainers/$userID/workouts/$collectionName/$subcollectionName").get();
    for (var docSnapshot in querySnapshot.docs) {
      if (docSnapshot.get('name') == title) {
        workouts = docSnapshot.get('groupOfWorkouts');
        break;
      }
    }
  } catch (e) {
    Exception("Error completing: $e");
  }
  return workouts;
}