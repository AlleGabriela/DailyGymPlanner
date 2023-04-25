import 'package:daily_gym_planner/routes/models/AppBar.dart';
import 'package:daily_gym_planner/routes/models/ListItems.dart';
import 'package:daily_gym_planner/routes/models/RiverMenu.dart';
import 'package:daily_gym_planner/routes/trainer/AddMeal.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../util/constants.dart';
import 'dart:ui';

class MealsList extends StatefulWidget{
  MealsListPage createState() => MealsListPage();
}

class MealsListPage extends State<MealsList>{

  String userName = "userName";

  @override
  void initState() {
    super.initState();
    _getUserDetails();
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

  final List<Category> categories = [
    Category(
      color: Colors.greenAccent.shade400,
      name: "Breakfast",
      imgName: "https://www.realsimple.com/thmb/2O3KDnWjXdzKndcvab-5IIiKDpU=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/gut-healthy-breakfast-GettyImages-1331452923-db3c1fa6a89f4498b4acadb590410d3d.jpg",
      icon: Icons.breakfast_dining
    ),
    Category(
        color: Colors.redAccent.shade400,
        name: "Lunch",
        imgName: "https://bindinutrition.com.au/wp-content/uploads/2021/08/1-3.png",
        icon: Icons.soup_kitchen
    ),
    Category(
        color: Colors.teal.shade700,
        name: "Dinner",
        imgName: "https://s3.amazonaws.com/img.mynetdiary.com/blog/healthy-quick-and-easy-dinner.jpg",
        icon: Icons.dinner_dining
    ),
    Category(
        color: Colors.purple,
        name: "Snack",
        imgName: "https://assets.sweat.com/html_body_blocks/images/000/004/717/original/HealthySnacks_en13b23c73ddbd637371781302b212e99a.jpg?1588647663",
        icon: Icons.bakery_dining
    ),
    Category(
        color: Colors.blue.shade800,
        name: "Full Day Meal",
        imgName: "https://motherhoodcommunity.com/wp-content/uploads/2022/03/20-Easy-Healthy-Lunch-Ideas-Your-Kids-Will-Love-At-Home-Or-In-School-845x563.png",
        icon: Icons.lunch_dining
    ),
    Category(
        color: Colors.yellow.shade900,
        name: "Meal Plan for a Week",
        imgName: "https://www.eatingwell.com/thmb/Z54SNPfHI6qLiUfm0DXZcrjVtxw=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/7-day-diet-meal-plan-1500-calories-lede-47e8de347b1e4c23ae0af72055c068d8.jpg",
        icon: Icons.fastfood
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: RiverMenu(
          userName: userName,
          selectedSection: "Meals",
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            MyAppBar(),
            SliverFillRemaining(
              child: Container(
                color: accentColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: lightLila,
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "\nWant to add something new? ",
                                style: TextStyle(
                                  color: buttonTextColor,
                                  fontSize: questionSize,
                                  fontFamily: font2,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddMealPage(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return Container(
                            margin: EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
                            height: 180,
                            child: GestureDetector(
                              // onTap: () {
                              //   Navigator.push(
                              //     context,
                              //     // MaterialPageRoute(
                              //     //   builder: (context) => BreakfastPage(),
                              //     // ),
                              //   );
                              // },
                              child: listItems(categories[index].name, categories[index].imgName, categories[index].icon, categories[index].color),
                            )
                          );
                        },
                      )
                    )
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Category {
  String name;
  IconData icon;
  Color color;
  String imgName;

  Category(
      {
        required this.name,
        required this.icon,
        required this.color,
        required this.imgName
      }
      );
}