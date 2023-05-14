import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../util/constants.dart';
import '../../models/ListItems.dart';
import '../../models/category.dart';
import 'WorkoutPlansDayWeek.dart';

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

  List<Category> subcategories = [];
  List<Widget> fullWorkout = [];

  CategoryListPage(this.categoryName, this.icon, this.iconColor);

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    handleUserID();
  }

  Future<void> _getUserDetails() async {
    FirebaseAuthMethods authService = FirebaseAuthMethods();
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    if (email != null) {
      String name = await authService.getName(email) ;
      setState(() {
        userName = name;
      });
    }
  }

  void handleUserID() async {
    FirebaseAuthMethods authMethods = FirebaseAuthMethods();
    String userId = await authMethods.getUserId();
    chooseSubcategory(userId);
    if( subcategories == [] && fullWorkout == []) {
      throw Exception("The list is still empty!");
    }
  }

  void chooseSubcategory(String userId) async{
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

    QuerySnapshot<Map<String, dynamic>> snapshot;

    if(categoryName == "Upper Body Workouts") {
      subcategories = subcategoryUpperBody.toList();
    }
    else if(categoryName == "Lower Body Workouts"){
      subcategories = subcategoryLowerBody.toList();
    }
    else if( categoryName == "One Day Workout") {
      snapshot = await FirebaseFirestore.instance
          .collection("trainers")
          .doc(userId)
          .collection("workouts")
          .doc("One Day Workouts")
          .collection("All One Day Workouts")
          .orderBy('name', descending: false)
          .get();
      if (snapshot.docs.isNotEmpty) {
        String name = "";
        fullWorkout = snapshot.docs.map((doc) {
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
                      .doc("One Day Workouts")
                      .collection("All One Day Workouts")
                      .doc(doc.id)
                      .delete();
                  setState(() {});
              },
              child: buildSubcategoryList(categoryName, name, subcategories, fullWorkout),
            );
        }).toList();
      }
    }
    else if( categoryName == "One Week Workout Plan") {
      snapshot = await FirebaseFirestore.instance
          .collection("trainers")
          .doc(userId)
          .collection("workouts")
          .doc("One Week Workout Plan")
          .collection("One Week Workout Plan")
          .orderBy('name', descending: false)
          .get();
      if (snapshot.docs.isNotEmpty) {
        String name = "";
        fullWorkout = snapshot.docs.map((doc) {
            name = doc['name'];
            if (name == '') {
              throw Exception("The one week workout plan cannot pe accessed!");
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
                    .doc("One Week Workout Plan")
                    .collection("One Week Workout Plan")
                    .doc(doc.id)
                    .delete();
                setState(() {});
              },
              child: buildSubcategoryList(categoryName, name, subcategories, fullWorkout),
            );
        }).toList();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if(categoryName == "Upper Body Workouts" || categoryName == "Lower Body Workouts") {
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
                      buildSubcategoryList(categoryName, categoryName, subcategories, fullWorkout),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    else {
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
              SliverList(
                delegate: SliverChildListDelegate(
                  fullWorkout,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget buildSubcategoryList(String categoryName, String title, List<Category> subcategories, List<Widget> fullWorkout) {
    if(categoryName == "Upper Body Workouts" || categoryName == "Lower Body Workouts") {
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
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
        height: 80,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutPlansDayWeek(
                  categoryName: categoryName,
                  title: title,
                  icon: Icons.fitness_center,
                  iconColor: primaryColor,
                ),
              ),
            );
          },
          child:  listItemsWithoutImage(title, Icons.fitness_center, primaryColor),
        ),
      );
    }
  }
}