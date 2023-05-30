import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/services/meal/MealServices.dart';
import 'package:flutter/material.dart';
import '../../../util/constants.dart';
import '../../models/ListItems.dart';
import 'MealDetails.dart';

class MealPlans extends StatefulWidget {
  final String userID;
  final String categoryName;
  final String title;
  final String? imageUrl;
  final String description;
  final double timeInHours;
  final double timeInMinutes;

  const MealPlans({super.key, required this.userID, required this.title, required this.description, this.imageUrl, required this.categoryName, required this.timeInHours, required this.timeInMinutes});

  @override
  State<MealPlans> createState() => _MealPlansState();
}

class _MealPlansState extends State<MealPlans> {
  String categoryName = '';

  List meals = [];
  List<Container> mealList = [];
  List imageList = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    categoryName = widget.categoryName;
  }

  Future<List<Container>> handleMealData() async {
    List<Container> listOfMeals = [];
    if (categoryName == "Full Day Meal") {
      meals = await getMealsFromFullDayMeal(widget.title, widget.userID);
      if (meals.isNotEmpty) {
        listOfMeals = [for (final meal in meals) await buildMealContainer(meal)];
      }
    } else if (categoryName == "Meal Plan for a Week") {
      imageList = ["assets/images/monday.jpg"] + ["assets/images/tuesday.jpg"] + ["assets/images/wednesday.jpg"] + ["assets/images/thursday.jpg"] + ["assets/images/friday.jpg"] + ["assets/images/saturday.jpg"] + ["assets/images/sunday.jpg"];
      meals = await getDayPlansFromOneWeekMeal(widget.title, widget.userID);
      if (meals.isNotEmpty) {
        index = 0;
        listOfMeals = [for (final meal in meals) await buildPlanContainer(meal)];
      }
    }
    return listOfMeals;
  }

  Future<Container> buildMealContainer(doc) async{
    String mealName = '';
    String mealImageUrl = '';
    String mealDescription = '';
    double mealTimeInHours = 0;
    double mealTimeInMinutes = 0;
    IconData? mealIcon;
    Color? mealIconColor;
    String mealID = "";

    await doc.get().then( (DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      mealName = data['name'];
      mealImageUrl = data['imageUrl'];
      mealDescription = data['description'];
      mealTimeInHours = data['timeInHours'];
      mealTimeInMinutes = data['timeInMinutes'];
      mealID = doc.id;
    },
      onError: (e) => Exception("Error getting document: $e"),
    );
    if( mealName == '' || mealImageUrl == '' || mealDescription == '') {
      throw Exception("The meal cannot pe accessed!");
    }

    Future<bool> checkCategory(String category) async {
      var a = await db.collection('trainers/${widget.userID}/meals/meal/$category').doc(mealID).get();
      if (a.exists) {
        return true;
      } else {
        return false;
      }
    }
    if (await checkCategory("Breakfast")) {
      mealIcon = Icons.breakfast_dining;
      mealIconColor = Colors.greenAccent.shade400;
    } else if (await checkCategory("Lunch"))  {
      mealIconColor = Colors.redAccent.shade400;
      mealIcon = Icons.soup_kitchen;
    } else if (await checkCategory("Dinner"))  {
      mealIconColor = Colors.teal.shade700;
      mealIcon = Icons.dinner_dining;
    } else {
      mealIconColor = Colors.purple;
      mealIcon = Icons.bakery_dining;
    }

    return Container(
        margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
        height: 180,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealDetails(
                  title: mealName,
                  imageUrl: mealImageUrl,
                  description: mealDescription,
                  timeInHours: mealTimeInHours,
                  timeInMinutes: mealTimeInMinutes,
                ),
              ),
            );
          },
          child: listItems(mealName, mealImageUrl, mealIcon, mealIconColor),
        )
    );
  }
  Future<Container> buildPlanContainer(doc) async{
    categoryName = "Full Day Meal";

    String planName = "";
    await doc.get().then( (DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      planName = data['name'];
    },
      onError: (e) => Exception("Error getting document: $e"),
    );
    if( planName == '') {
      throw Exception("The plan cannot pe accessed!");
    }

    return Container(
        margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
        height: 180,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MealPlans(
                      userID: widget.userID,
                      title: planName,
                      description: widget.description,
                      categoryName: categoryName,
                      timeInHours: widget.timeInHours,
                      timeInMinutes: widget.timeInMinutes
                  )
              ),
            );
          },
          child: listItemsUsingImageAsset(planName, imageList[index++], Icons.lunch_dining, Colors.blue.shade800),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (categoryName == "Full Day Meal" || categoryName == "Meal Plan for a Week") {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
              title: Text(widget.title),
              backgroundColor: primaryColor,
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon:const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              )
          ),
          body: FutureBuilder(
            future: handleMealData(),
            builder: (context, snapshot) {
              mealList = [];
              var snapData = snapshot.data;
              if (snapData != null) {
                mealList += snapData;
              }
              return snapshot.hasData
                ? ListView(
                  children: mealList,
                )
                : const Center(
                  child: CircularProgressIndicator(
                    valueColor:AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                );
            },
          ),
        ),
      );
    } else {
      return MealDetails(title: widget.title, imageUrl: widget.imageUrl, description: widget.description, timeInMinutes: widget.timeInMinutes, timeInHours: widget.timeInHours);
    }
  }
}

