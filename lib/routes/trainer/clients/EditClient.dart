import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../services/ClientServices.dart';
import '../../../services/MealServices.dart';
import '../../../services/auth_methods.dart';
import '../../../services/workout/OneWeekWorkoutServices.dart';
import '../../../services/workout/WorkoutServices.dart';
import '../../../util/components_theme/box.dart';
import '../../../util/constants.dart';
import '../../../util/showSnackBar.dart';
import 'ClientsListPage.dart';

class EditClientPage extends StatefulWidget {
  final dynamic clientName;
  final dynamic clientEmail;
  final dynamic clientPhoto;
  final dynamic clientLocation;
  final dynamic clientWorkoutPlan;
  final dynamic clientMealPlan;
  final dynamic clientID;

  const EditClientPage({Key? key, this.clientName, this.clientEmail, this.clientPhoto, this.clientLocation, this.clientWorkoutPlan, this.clientMealPlan, this.clientID}) : super(key: key);

  @override
  State<EditClientPage> createState() => _EditClientPageState();
}

class _EditClientPageState extends State<EditClientPage> {

  late Future<String> mealPlanName;
  late Future<String> workoutPlanName;
  String selectedMealPlan = "None";
  String selectedWorkoutPlan = "None";
  List<String> listWorkoutPlans = [];
  List<String> listMealPlans = [];
  late Future<List<String>> fetchWorkouts;
  late Future<List<String>> fetchMeals;

  @override
  void initState() {
    super.initState();
    mealPlanName = getMealPlanName(widget.clientMealPlan);
    workoutPlanName = getWorkoutPlanName(widget.clientWorkoutPlan);
    fetchWorkouts = getWorkoutPlans(userID);
    fetchMeals = getMealPlans(userID);
  }

  FirebaseAuthMethods authMethods = FirebaseAuthMethods();
  FirebaseFirestore db = FirebaseFirestore.instance;

  String userID = FirebaseAuth.instance.currentUser!.uid;

  void _editClient() async {

    final client = Client(
      userID,
      widget.clientID,
      selectedWorkoutPlan,
      selectedMealPlan,
    );
    try {
      await client.editClient();
      showSnackBar(context, "Client succesfully edited!");
      Navigator.pop(context);
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => ClientsList(),
        ),
      );
    } catch (e) {
      throw Exception('Error editing client: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: addPagesBackgroundColor,
      appBar: AppBar(
        title: const Text("Edit Client Plans"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column (
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: (widget.clientPhoto == '') ? const AssetImage('assets/images/user.png') as ImageProvider : NetworkImage(widget.clientPhoto),
                ),
              ),
              Text(
                "Name: ${widget.clientName}",
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: questionSize,
                  fontFamily: font2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "E-mail: ${widget.clientEmail}",
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: questionSize,
                  fontFamily: font2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Location: ${widget.clientLocation}",
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: questionSize,
                  fontFamily: font2,
                ),
              ),
              const SizedBox(height: 32),
              FutureBuilder<String>(
                future: mealPlanName,
                builder: (context, snapshot) {
                  var snapData = snapshot.data;
                  if (snapData != null) {
                    selectedMealPlan = snapData;
                  }
                  return snapshot.hasData
                      ? FutureBuilder<List<String>>(
                          future: fetchMeals,
                          builder: (context, snapshot) {
                            listMealPlans = ['None'];
                            var snapData = snapshot.data;
                            if (snapData != null) {
                              listMealPlans += snapData;
                            }
                            return snapshot.hasData
                                ? section("Meal Plan", selectedMealPlan, listMealPlans, Icons.fastfood)
                                : const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        )
                      : const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<String>(
                future: workoutPlanName,
                builder: (context, snapshot) {
                  var snapData = snapshot.data;
                  if (snapData != null) {
                    selectedWorkoutPlan = snapData;
                  }
                  return snapshot.hasData
                      ? FutureBuilder<List<String>>(
                          future: fetchWorkouts,
                          builder: (context, snapshot) {
                            listWorkoutPlans = ['None'];
                            var snapData = snapshot.data;
                            if (snapData != null) {
                              listWorkoutPlans += snapData;
                            }
                            return snapshot.hasData
                                ? section("Workout Plan", selectedWorkoutPlan, listWorkoutPlans, Icons.fitness_center_outlined)
                                : const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        )
                      : const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  height: 45,
                  width: 200,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            Colors.purple.shade600,
                            Colors.purple.shade500,
                            Colors.purple.shade400,
                          ]
                      )
                  ),
                  child: ElevatedButton(
                    onPressed: _editClient,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    child: const Text('Update'),
                  ),
                ),
              )
            ]
          )
        )
      ),
    );
  }
  Column section (String title, String itemChoose, List listItems, IconData icon) {
    return Column(
      children: [
        const SizedBox(height: 16),
        titleStyle(title, questionSize),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: DropdownButtonFormField(
            style: TextStyle(color: Colors.grey.shade800, fontFamily: font1),
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              border: const OutlineInputBorder(),
              prefixIconColor: primaryColor ,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple, width: 1),
              ),
            ),
            dropdownColor: dropdownFieldColor,
            value: itemChoose,
            validator: (value) {
              if (value == null) {
                showSnackBar( context, 'Please choose ${title.toLowerCase()}.');
              }
              return null;
            },
            items: listItems.map(
                    (e) =>
                    DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    )
            ).toList(),
            onChanged: (val) {
              setState(() {
                itemChoose = val as String;
                switch(title) {
                  case "Workout Plan":
                    {
                      selectedWorkoutPlan = itemChoose;
                      workoutPlanName = Future.value(selectedWorkoutPlan);
                    }
                    break;
                  case "Meal Plan":
                    {
                      selectedMealPlan = itemChoose;
                      mealPlanName = Future.value(selectedMealPlan);
                    }
                    break;
                }
              });
            },
          )
        )
      ],
    );
  }
}


