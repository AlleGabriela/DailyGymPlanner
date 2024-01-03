import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/routes/trainer/clients/ClientsListPage.dart';
import 'package:daily_gym_planner/services/meal/MealServices.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:daily_gym_planner/services/workout/WorkoutServices.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:daily_gym_planner/util/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/ClientServices.dart';
import '../../../util/components_theme/box.dart';

List<String> listWorkoutPlans = [];
List<String> listMealPlans = [];

class AddClientPage extends StatefulWidget {
  const AddClientPage({Key? key}) : super(key: key);

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String workoutPlan = 'None';
  String mealPlan = 'None';
  bool feedback = false;

  late Future<List<String>> fetchWorkouts;
  late Future<List<String>> fetchMeals;

  @override
  void initState() {
    super.initState();
    fetchWorkouts = getWorkoutPlans(userID);
    fetchMeals = getMealPlans(userID);
  }

  FirebaseAuthMethods authMethods = FirebaseAuthMethods();
  FirebaseFirestore db = FirebaseFirestore.instance;

  String userID = FirebaseAuth.instance.currentUser!.uid;
  String customerID = '';

  void submitForm() async {
    if (formKey.currentState != null &&
        formKey.currentState!.validate())
    {
      formKey.currentState!.save();
      customerID = await authMethods.getCustomerID(email);

      if (!(await authMethods.doesUserExist(email) && (await authMethods.getRole(email)) == "Customer")) {
        showSnackBar(context, 'Customer with email address $email does not exist');
      } else if (await trainerHasThisClient(email, userID)) {
        showSnackBar(context, 'You have already added this customer');
      } else {
        final client = Client(
          userID,
          customerID,
          workoutPlan,
          mealPlan,
          feedback
        );
        try {
          await client.addClient();
          showSnackBar(context, "Client added successfully!");
          Navigator.pop(context);
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const ClientsList(),
            ),
          );
        } catch (e) {
          throw Exception('Error adding client to Firestore: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: addPagesBackgroundColor,
      appBar: AppBar(
        title: const Text('Add Client'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              const Text(
                  "Email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: questionSize,
                    fontFamily: font1,
                  )
              ),
              TextFormField(
                decoration: //addPageInputStyle(""),
                const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  prefixIconColor: primaryColor ,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 1),
                  ),
                ),
                cursorColor: inputDecorationColor,
                maxLength: 30,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    showSnackBar( context, 'Please enter an email.');
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value ?? '';
                },
              ),
              const SizedBox(height: 32),
              FutureBuilder<List<String>>(
                future: fetchWorkouts,
                builder: (context, snapshot) {
                  listWorkoutPlans = ['None'];
                  var snapData = snapshot.data;
                  if (snapData != null) {
                    listWorkoutPlans += snapData;
                  }
                  return snapshot.hasData
                      ? section("Workout Plan", listWorkoutPlans[0], listWorkoutPlans, Icons.fitness_center_outlined)
                      : const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              const SizedBox(height: 50),
              FutureBuilder<List<String>>(
                future: fetchMeals,
                builder: (context, snapshot) {
                  listMealPlans = ['None'];
                  var snapData = snapshot.data;
                  if (snapData != null) {
                    listMealPlans += snapData;
                  }
                  return snapshot.hasData
                      ? section("Meal Plan", listMealPlans[0], listMealPlans, Icons.fastfood)
                      : const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              const SizedBox(height: 64),
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
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    child: const Text('Save'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column section (String title, String itemChoose, List listItems, IconData icon) {
    return Column(
      children: [
        const SizedBox(height: 16),
        titleStyle(title, questionSize),
        const SizedBox(height: 16),
        DropdownButtonFormField(
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
                    workoutPlan = itemChoose;
                  }
                  break;
                case "Meal Plan":
                  {
                    mealPlan = itemChoose;
                  }
                  break;
              }
            });
          },
        )
      ],
    );
  }
}