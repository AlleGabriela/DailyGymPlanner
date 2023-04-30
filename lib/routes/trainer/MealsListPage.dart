import 'package:daily_gym_planner/routes/models/AppBar.dart';
import 'package:daily_gym_planner/routes/models/ListItems.dart';
import 'package:daily_gym_planner/routes/models/RiverMenu.dart';
import 'package:daily_gym_planner/routes/trainer/AddMeal.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../util/constants.dart';

class MealsList extends StatefulWidget{
  const MealsList({super.key});

  @override
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
      imgName: "assets/images/breakfast.jpg",
      icon: Icons.breakfast_dining
    ),
    Category(
        color: Colors.redAccent.shade400,
        name: "Lunch",
        imgName: "assets/images/lunch.jpg",
        icon: Icons.soup_kitchen
    ),
    Category(
        color: Colors.teal.shade700,
        name: "Dinner",
        imgName: "assets/images/dinner.jpg",
        icon: Icons.dinner_dining
    ),
    Category(
        color: Colors.purple,
        name: "Snack",
        imgName: "assets/images/snack.jpg",
        icon: Icons.bakery_dining
    ),
    Category(
        color: Colors.blue.shade800,
        name: "Full Day Meal",
        imgName: "assets/images/fulldaymeal.jpg",
        icon: Icons.lunch_dining
    ),
    Category(
        color: Colors.yellow.shade900,
        name: "Meal Plan for a Week",
        imgName: "assets/images/mealplan.jpg",
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
            const MyAppBar(),
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
                                style: const TextStyle(
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
                            margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
                            height: itemListHeight,
                            child: GestureDetector(
                              // onTap: () {
                              //   Navigator.push(
                              //     context,
                              //     // MaterialPageRoute(
                              //     //   builder: (context) => BreakfastPage(),
                              //     // ),
                              //   );
                              // },
                              child: listItemsUsingImageAsset(categories[index].name, categories[index].imgName, categories[index].icon, categories[index].color),
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