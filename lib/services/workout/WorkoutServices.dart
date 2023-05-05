import 'package:cloud_firestore/cloud_firestore.dart';

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
