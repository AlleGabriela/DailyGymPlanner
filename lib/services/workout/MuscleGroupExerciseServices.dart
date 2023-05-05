import 'package:cloud_firestore/cloud_firestore.dart';

class GroupExercise {
  String name;
  String nrSeries;
  String nrReps;

  GroupExercise(this.name, this.nrSeries, this.nrReps);
}

class MuscleGroupExercise {
  String userID;
  String category;
  String subcategory;
  String name;
  List groupExercise;

  MuscleGroupExercise(this.userID, this.category, this.subcategory, this.name, this.groupExercise);

  Future<void> addMuscleGroupExerciseToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    try {
      if( name == ""  ) {
        throw Exception('Field cannot be empty.');
      }

      await firestore.collection("trainers")
          .doc(userID)
          .collection("workouts")
          .doc(category)
          .collection(subcategory)
          .doc(subcategory)
          .collection("Muscle Group Exercise")
          .add({'name': name,
                'groupExercise': groupExercise,
                'createdAt': DateTime.now().toUtc(),});
    } catch (e) {
      throw Exception('Muscle Group Exercise cannot be added to firebase.');
    }
  }
}