import 'package:cloud_firestore/cloud_firestore.dart';

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
