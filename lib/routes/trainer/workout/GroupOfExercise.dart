import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/routes/models/ListItems.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:flutter/material.dart';
import '../../../util/constants.dart';

class GroupOfExercise extends StatefulWidget{
  final String categoryName;
  final String subcategoryName;

  const GroupOfExercise({super.key, required this.categoryName, required this.subcategoryName});

  @override
  GroupOfExercisePage createState() => GroupOfExercisePage(categoryName, subcategoryName);
}

class GroupOfExercisePage extends State<GroupOfExercise> {
  String userName = "userName";
  String categoryName = "";
  String subcategoryName = "";

  List<Widget> exerciseList = [];

  GroupOfExercisePage(this.categoryName, this.subcategoryName);

  @override
  void initState() {
    super.initState();
    handleUserID();
  }

  void handleUserID() async {
    FirebaseAuthMethods authMethods = FirebaseAuthMethods();
    String userId = await authMethods.getUserId();
    getSubcategoryItems(userId);
    if( exerciseList == []) {
      throw Exception("The list is still empty!");
    }
  }

  void getSubcategoryItems(String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot;

    snapshot = await FirebaseFirestore.instance
        .collection("trainers")
        .doc(userId)
        .collection("workouts")
        .doc(categoryName)
        .collection(subcategoryName)
        .doc(subcategoryName)
        .collection("Muscle Group Exercise")
        .orderBy('name', descending: false)
        .get();
    if (snapshot.docs.isNotEmpty) {
      String name = "";
      exerciseList = snapshot.docs.map((doc) {
        name = doc['name'];
        if( name == '') {
          throw Exception("The one day workout cannot pe accessed!");
        }
        return Dismissible(
          key: Key(doc.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          onDismissed: (direction) async {
            await FirebaseFirestore.instance
                .collection("trainers")
                .doc(userId)
                .collection("workouts")
                .doc(categoryName)
                .collection(subcategoryName)
                .doc(subcategoryName)
                .collection("Muscle Group Exercise")
                .doc(doc.id)
                .delete();
            setState(() {});
          },
          child: buildGroupOfExerciseList(categoryName, subcategoryName, name, exerciseList),
        );
      }).toList();
    }
    setState(() {});
  }

  Widget buildGroupOfExerciseList(String categoryName, String subcategoryName, String name, List<Widget> exerciseList) {
    return Container(
      margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
      height: 80,
      child: GestureDetector(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => WorkoutPlansDayWeek(
          //       categoryName: categoryName,
          //       title: title,
          //       icon: Icons.fitness_center,
          //       iconColor: primaryColor,
          //     ),
          //   ),
          // );
        },
        child:  listItemsWithoutImage(name, Icons.fitness_center, primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text(subcategoryName),
            backgroundColor: primaryColor,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon:const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                exerciseList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}