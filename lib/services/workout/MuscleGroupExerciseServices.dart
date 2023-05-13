import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth_methods.dart';

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

Future<String> getMuscleGroupReference(String category, String subcategory, String selectedExercise) async {
  String userID = await FirebaseAuthMethods().getUserId();
  String exerciseGroupID = "";
  final firestore = FirebaseFirestore.instance;
  String collectionName = "Muscle Group Exercise";

  try {
    await firestore.collection("trainers/$userID/workouts/$category/$subcategory/$subcategory/$collectionName").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.get('name') == selectedExercise) {
            exerciseGroupID = docSnapshot.id;
            break;
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    // for (var docSnapshot in querySnapshot.docs) {
    //     if (docSnapshot.get('name') == collectionName) {
    //       exerciseGroupID = docSnapshot.id;
    //       break;
    //     }
    // }
  } catch (e) {
    Exception("Error completing: $e");
  }
  if (exerciseGroupID != "") {
    return firestore.doc("trainers/$userID/workouts/$category/$subcategory/$subcategory/$collectionName/$exerciseGroupID").path;
  } else {
    return "";
  }
}

Future<List<String>> getMuscleGroupWorkoutsName(String category, String subcategory) async {
  String userID = await FirebaseAuthMethods().getUserId();
  final firestore = FirebaseFirestore.instance;
  List<String> muscleGroupsNames = [];
  String collectionName = "Muscle Group Exercise";

  try {
    final querySnapshot = await firestore.collection("trainers/$userID/workouts/$category/$subcategory/$subcategory/$collectionName").get();
    for (var docSnapshot in querySnapshot.docs) {
      muscleGroupsNames.add(docSnapshot.get('name'));
    }
  } catch (e) {
    Exception("Error completing: $e");
  }
  return muscleGroupsNames;
}