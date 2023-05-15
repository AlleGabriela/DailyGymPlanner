import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:flutter/material.dart';
import '../../../util/constants.dart';
import 'GroupOfExercise.dart';

class SubcategoryExercise extends StatefulWidget{
  final String categoryName;
  final String subcategoryName;

  const SubcategoryExercise({super.key, required this.categoryName, required this.subcategoryName});

  @override
  SubcategoryExercisePage createState() => SubcategoryExercisePage(categoryName, subcategoryName);
}

class SubcategoryExercisePage extends State<SubcategoryExercise>{
  String userName = "userName";
  String categoryName = "";
  String subcategoryName = "";

  List exercises = [];
  List<Widget> exerciseList = [];

  SubcategoryExercisePage(this.categoryName, this.subcategoryName);

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
    if (categoryName == "Upper Body Workouts") {
      categoryName = "Upper Body";
    } else {
      categoryName = "Lower Body";
    }
    snapshot = await FirebaseFirestore.instance
        .collection("trainers")
        .doc(userId)
        .collection("workouts")
        .doc(categoryName)
        .collection(subcategoryName)
        .doc(subcategoryName)
        .collection("Simple Exercise")
        .orderBy('name', descending: false)
        .get();

    if (snapshot.docs.isNotEmpty) {
      String name = "";
      int index = 1;
      exerciseList = snapshot.docs.map((doc) {
        name = doc['name'];
        if( name == '') {
          throw Exception("The exercise cannot pe accessed!");
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
                .collection("Simple Exercise")
                .doc(doc.id)
                .delete();
            setState(() {});
          },
          child: buildGroupOfExerciseList(index++, name),
        );
      }).toList();
    }
    setState(() {});

  }

  Widget buildGroupOfExerciseList( int index, String name) {
    return Container(
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: primaryColor,
            child: Text('$index'),
          ),
          title: Row(
            children: [
              Flexible(
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.black, fontFamily: font1),
                ),
              ),
            ],
          ),
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
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupOfExercise(
                        categoryName: categoryName,
                        subcategoryName: subcategoryName,
                      ),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(20),
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: lightLila,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Tap to see the exercise groups",
                    style: TextStyle(fontSize: 20, color: Colors.black87, fontFamily: font1),
                  ),
                ),
              ),
            ),
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