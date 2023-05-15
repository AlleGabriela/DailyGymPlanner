import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth_methods.dart';

class Workout {
  String userID;
  String category;
  String subcategory;
  String name;

  Workout(this.userID, this.category, this.subcategory, this.name);

  Future<void> addWorkoutToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    try {
      if( name == "" ) {
        throw Exception('Field cannot be empty.');
      }

      await firestore.collection("trainers")
          .doc(userID)
          .collection("workouts")
          .doc(category)
          .collection(subcategory)
          .doc(subcategory)
          .collection("Simple Exercise")
          .add({'name': name,
                'createdAt': DateTime.now().toUtc(),});
    } catch (e) {
      throw Exception('Workout cannot be added to firebase.');
    }
  }
}

Future<List<String>> getExercisesName(String category, String subcategory) async {
  String userID = await FirebaseAuthMethods().getUserId();
  final firestore = FirebaseFirestore.instance;
  List<String> exercisesNames = [];
  String exercise = "Simple Exercise";

  try {
    final querySnapshot = await firestore.collection("trainers/$userID/workouts/$category/$subcategory/$subcategory/$exercise").get();
    for (var docSnapshot in querySnapshot.docs) {
      exercisesNames.add(docSnapshot.get('name'));
    }
  } catch (e) {
    Exception("Error completing: $e");
  }
  return exercisesNames;
}


