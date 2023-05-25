import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';

import '../../models/ListItems.dart';
import 'MealPlans.dart';

class MealList extends StatefulWidget {
  final String categoryName;
  final IconData icon;
  final Color iconColor;

  const MealList({super.key, required this.categoryName, required this.icon, required this.iconColor});

  @override
  State<MealList> createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  String userId = '';
  List<Widget> mealList = [];
  String userName = "";
  double imageHeight = 180;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    handleUserID();
  }

  Future<void> _getUserDetails() async {

    FirebaseAuthMethods _authService = FirebaseAuthMethods();
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    if (email != null) {
      String name = await _authService.getName(email) ;
      setState(() {
        userName = name;
      });
    }
  }

  void handleUserID() async {
    FirebaseAuthMethods authMethods = FirebaseAuthMethods();
    userId = await authMethods.getUserId();
    handleMealData();
    if( mealList == []) {
      throw Exception("The list is still empty!");
    }
  }

  void handleMealData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (widget.categoryName == "Breakfast" || widget.categoryName == "Lunch" || widget.categoryName == "Snack" || widget.categoryName == "Dinner") {
      snapshot = await FirebaseFirestore.instance
        .collection("trainers")
        .doc(userId)
        .collection("meals")
        .doc("meal")
        .collection(widget.categoryName)
        .orderBy('name', descending: false)
        .get();
    } else if (widget.categoryName == "Full Day Meal") {
      snapshot = await FirebaseFirestore.instance
          .collection("trainers")
          .doc(userId)
          .collection("meals")
          .doc("one day meal plan")
          .collection("One Day Meal Plan")
          .orderBy('name', descending: false)
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection("trainers")
          .doc(userId)
          .collection("meals")
          .doc("one week meal plan")
          .collection("One Week Meal Plan")
          .orderBy('name', descending: false)
          .get();
    }

    if (snapshot.docs.isNotEmpty) {
      mealList = snapshot.docs.map((doc) {
        String name;
        String imageUrl = '';
        String description = "";
        double timeInHours = 0;
        double timeInMinutes = 0;
        if (widget.categoryName == "Breakfast" || widget.categoryName == "Lunch" || widget.categoryName == "Snack" || widget.categoryName == "Dinner") {
          name = doc['name'];
          imageUrl = doc['imageUrl'];
          description = doc['description'];
          timeInHours = doc['timeInHours'];
          timeInMinutes = doc['timeInMinutes'];

          if( name == '' || imageUrl == '' || description == '') {
            throw Exception("The meal cannot pe accessed!");
          }
        } else if (widget.categoryName == "Full Day Meal") {
          imageHeight = 80;
          name = doc['name'];

          if( name == '') {
            throw Exception("The full day meal cannot pe accessed!");
          }
        } else {
          imageHeight = 80;
          name = doc['name'];

          if( name == '' ) {
            throw Exception("The full week meal plan cannot pe accessed!");
          }
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
            if (widget.categoryName == "Breakfast" || widget.categoryName == "Lunch" || widget.categoryName == "Snack" || widget.categoryName == "Dinner") {
              await FirebaseFirestore.instance
                .collection("trainers")
                .doc(userId)
                .collection("meals")
                .doc("meal")
                .collection(widget.categoryName)
                .doc(doc.id)
                .delete();
              setState(() {});
            } else if (widget.categoryName == "Full Day Meal") {
              await FirebaseFirestore.instance
                .collection("trainers")
                .doc(userId)
                .collection("meals")
                .doc("one day meal plan")
                .collection("One Day Meal Plan")
                .doc(doc.id)
                .delete();
              setState(() {});
            } else {
              await FirebaseFirestore.instance
                .collection("trainers")
                .doc(userId)
                .collection("meals")
                .doc("one week meal plan")
                .collection("One Week Meal Plan")
                .doc(doc.id)
                .delete();
              setState(() {});
            }
          },
          child: Container(
              margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
              height: imageHeight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealPlans(
                        categoryName: widget.categoryName,
                        title: name,
                        imageUrl: imageUrl,
                        description: description,
                        timeInHours: timeInHours,
                        timeInMinutes: timeInMinutes,
                      ),
                    ),
                  );
                },
                child: listMeals(name, imageUrl, widget.icon, widget.iconColor),
              )
          ),
        );
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName),
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
                mealList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack listMeals(String title, String imageUrl, IconData icon, Color iconColor) {
    if (widget.categoryName == "Breakfast" || widget.categoryName == "Lunch" || widget.categoryName == "Snack" || widget.categoryName == "Dinner") {
      return listItems(title, imageUrl, icon, iconColor);
    } else {
      return listItemsWithoutImage(title, icon, iconColor);
    }
  }
}