import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../util/constants.dart';
import '../../models/ListItems.dart';
import '../../models/category.dart';

class CategoryList extends StatefulWidget{
  final String categoryName;
  final IconData icon;
  final Color iconColor;
  const CategoryList({super.key, required this.categoryName, required this.icon, required this.iconColor});

  @override
  CategoryListPage createState() => CategoryListPage(categoryName, icon, iconColor);
}

class CategoryListPage extends State<CategoryList>{
  String userName = "userName";
  String categoryName = "";
  IconData icon;
  Color iconColor;

  List<Category> subcategoryUpperBody = [
    Category(
        color: primaryColor,
        name: "Abs",
        icon: Icons.fitness_center,
        imgName: 'assets/images/abs.jpeg'
    ),
    Category(
        color: primaryColor,
        name: "Back",
        icon: Icons.fitness_center,
        imgName: 'assets/images/back.jpeg'
    ),
    Category(
        color: primaryColor,
        name: "Biceps",
        icon: Icons.fitness_center,
        imgName: 'assets/images/biceps.jpeg'
    ),
    Category(
        color: primaryColor,
        name: "Chest",
        icon: Icons.fitness_center,
        imgName: 'assets/images/chest.jpeg'
    ),
    Category(
        color: primaryColor,
        name: "Shoulders",
        icon: Icons.fitness_center,
        imgName: 'assets/images/shoulders.jpeg'
    ),
    Category(
        color: primaryColor,
        name: "Traps",
        icon: Icons.fitness_center,
        imgName: 'assets/images/traps.jpeg'
    ),
    Category(
        color: primaryColor,
        name: "Triceps",
        icon: Icons.fitness_center,
        imgName: 'assets/images/triceps.jpeg'
    ),
  ];
  List<Category> subcategoryLowerBody = [
    Category(
        color: primaryColor,
        name: "Calves",
        icon: Icons.fitness_center,
        imgName: 'assets/images/calves.jpeg'
    ),
    Category(
        color: primaryColor,
        name: "Hamstrings",
        icon: Icons.fitness_center,
        imgName: 'assets/images/hamstrings.jpeg'
    ),
    Category(
        color: primaryColor,
        name: "Glutes",
        icon: Icons.fitness_center,
        imgName: 'assets/images/glutes.jpeg'
    ),
    Category(
        color: primaryColor,
        name: "Quads",
        icon: Icons.fitness_center,
        imgName: 'assets/images/quads.jpeg'
    )
  ];
  List<Category> subcategories = [];

  CategoryListPage(this.categoryName, this.icon, this.iconColor);

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    chooseSubcategory();
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

  void chooseSubcategory() {
    if(categoryName == "Upper Body Workouts") {
      subcategories = subcategoryUpperBody.toList();
    }
    else if(categoryName == "Lower Body Workouts"){
      subcategories = subcategoryLowerBody.toList();
    }
    else if( categoryName == "One Day Workout") {

    }
    else if( categoryName == "One Week Workout Plan") {

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text(categoryName),
            backgroundColor: primaryColor,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon:const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              child: Container(
                color: accentColor,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildSubcategoryList(subcategories),
                    ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSubcategoryList(List<Category> subcategories) {
    return Expanded(
      child: ListView.builder(
        itemCount: subcategories.length,
        itemBuilder: (BuildContext ctx, int index) {
          return Container(
            margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
            height: itemListHeight,
            child: GestureDetector(
              onTap: () {
              },
              child: listItemsUsingImageAsset(subcategories[index].name, subcategories[index].imgName, subcategories[index].icon, subcategories[index].color),
            ),
          );
        },
      ),
    );
  }
}