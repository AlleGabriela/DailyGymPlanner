import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  String userID;
  String title;
  String imageUrl;
  String description;
  DateTime createdAt;

  News(this.userID, this.title, this.imageUrl, this.description, this.createdAt);

  Future<void> addToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    try {
      if( title == "" || imageUrl == "" || description == "") {
        throw Exception('Field cannot be empty.');
      }

      await firestore.collection("trainers")
          .doc(userID)
          .collection("news")
          .add({'title': title,
                'imageUrl': imageUrl,
                'description': description,
                'createdAt': createdAt.toUtc(),});
    } catch (e) {
      throw Exception('News cannot be added to firebase.');
    }
  }
}
