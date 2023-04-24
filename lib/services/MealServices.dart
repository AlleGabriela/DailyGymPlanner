import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  String userID;
  String category;
  String name;
  String description;
  double timeInHours;
  double timeInMinutes;

  Meal(this.userID, this.category, this.name, this.description, this.timeInHours, this.timeInMinutes);

  Future<void> addToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    try {
      if( category == "" || name == "" || description == "" || timeInMinutes == 0) {
        throw Exception('Field cannot be empty.');
      }

      await firestore.collection("trainers")
        .doc(userID)
        .collection("meals")
        .add({'name': name,
              'description': description,
              'timeInHours': timeInHours,
              'timeInMinutes': timeInMinutes});
    } catch (e) {
      throw Exception('Meal cannot be added to firebase.');
    }
  }

}
