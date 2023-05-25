import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/MealServices.dart';
import '../../services/auth_methods.dart';
import '../../util/constants.dart';
import '../models/AppBar.dart';
import '../models/ListItems.dart';
import '../models/RiverMenu.dart';
import '../trainer/meals/MealPlans.dart';

class CustomerMeal extends StatefulWidget{
  const CustomerMeal({super.key});

  @override
  State<CustomerMeal> createState() => _CustomerMealPage();
}

class _CustomerMealPage extends State<CustomerMeal> {
  String trainerID = "";
  String? customerID = "";
  String userName = "userName";
  String userRole = "customer";
  late Future<List<String>> customerMealPlansNames;
  final List imageList = ["assets/images/monday.jpg"] + ["assets/images/tuesday.jpg"] + ["assets/images/wednesday.jpg"] + ["assets/images/thursday.jpg"] + ["assets/images/friday.jpg"] + ["assets/images/saturday.jpg"] + ["assets/images/sunday.jpg"];

  late Future<Map<dynamic, dynamic>> fetchDetails;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    customerMealPlansNames = getNamesOfCustomerMealPlans(customerID!);
  }

  void _getUserDetails() async {
    FirebaseAuthMethods authService = FirebaseAuthMethods();
    User? user = FirebaseAuth.instance.currentUser;
    customerID = user?.uid;

    String? email = user?.email;
    if (email != null) {
      userName = await authService.getName(email);
      trainerID = await authService.getTrainer(email);
      setState(() {});
    }
  }

  // Future<Container> buildMealContainer(doc) async{
  //   String mealName = '';
  //   String mealImageUrl = '';
  //   String mealDescription = '';
  //   double mealTimeInHours = 0;
  //   double mealTimeInMinutes = 0;
  //   IconData? mealIcon;
  //   Color? mealIconColor;
  //   String mealID = "";
  //
  //   await doc.get().then( (DocumentSnapshot doc) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     mealName = data['name'];
  //     mealImageUrl = data['imageUrl'];
  //     mealDescription = data['description'];
  //     mealTimeInHours = data['timeInHours'];
  //     mealTimeInMinutes = data['timeInMinutes'];
  //     mealID = doc.id;
  //   },
  //     onError: (e) => print("Error getting document: $e"),
  //   );
  //   if( mealName == '' || mealImageUrl == '' || mealDescription == '') {
  //     throw Exception("The meal cannot pe accessed!");
  //   }
  //
  //   Future<bool> checkCategory(String category) async {
  //     var a = await db.collection('trainers/$userID/meals/meal/$category').doc(mealID).get();
  //     if (a.exists) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }
  //   if (await checkCategory("Breakfast")) {
  //     mealIcon = Icons.breakfast_dining;
  //     mealIconColor = Colors.greenAccent.shade400;
  //   } else if (await checkCategory("Lunch"))  {
  //     mealIconColor = Colors.redAccent.shade400;
  //     mealIcon = Icons.soup_kitchen;
  //   } else if (await checkCategory("Dinner"))  {
  //     mealIconColor = Colors.teal.shade700;
  //     mealIcon = Icons.dinner_dining;
  //   } else {
  //     mealIconColor = Colors.purple;
  //     mealIcon = Icons.bakery_dining;
  //   }
  //
  //   return Container(
  //       margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
  //       height: 180,
  //       child: GestureDetector(
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => MealDetails(
  //                 title: mealName,
  //                 imageUrl: mealImageUrl,
  //                 description: mealDescription,
  //                 timeInHours: mealTimeInHours,
  //                 timeInMinutes: mealTimeInMinutes,
  //               ),
  //             ),
  //           );
  //         },
  //         child: listItems(mealName, mealImageUrl, mealIcon, mealIconColor),
  //       )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: RiverMenu(
          userRole: userRole,
          userName: userName,
          selectedSection: "Meals",
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            MyAppBar(userRole: userRole),
            SliverFillRemaining(
              child: FutureBuilder<List<String>>(
                future: customerMealPlansNames,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext ctx , int index) {
                        return Container(
                          margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
                          height: 180,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MealPlans(
                                        title: snapshot.data![index],
                                        description: '',
                                        categoryName: "Full Day Meal",
                                        timeInHours: 0,
                                        timeInMinutes: 0
                                    )
                                ),
                              );
                            },
                            child: listItemsUsingImageAsset(snapshot.data![index], imageList[index], Icons.lunch_dining, Colors.blue.shade800),
                          )
                        );
                      }
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      );
                  } else {
                    return const Text(
                      'Your meal plan is not set yet!',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: questionSize,
                        fontFamily: font2,
                      ),
                    );
                  }
                },
              ),
            )
          ]
        ),
      )
    );
  }
}
