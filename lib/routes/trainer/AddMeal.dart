import 'package:daily_gym_planner/routes/trainer/MealsListPage.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:daily_gym_planner/util/showSnackBar.dart';
import 'package:flutter/material.dart';

import '../../services/MealServices.dart';
import '../../util/components_theme/box.dart';

String valueChoose = "Breakfast";
List listItem = [
  "Breakfast", "Snack", "Lunch", "Dinner", "Full Day Meal", "One Week Meal Plan"
];

String mealChoose = "Choose meal:";
List listMeals = [
  "Choose meal:"
];

class AddMealPage extends StatefulWidget {
  const AddMealPage({Key? key}) : super(key: key);

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _formKey = GlobalKey<FormState>();
  String _category = valueChoose = "Breakfast";
  String _name = '';
  String _description = '';
  double _timeInHours = 0;
  double _timeInMinutes = 0;


  FirebaseAuthMethods authMethods = FirebaseAuthMethods();

  void _submitForm() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate())
    {
      _formKey.currentState!.save();
      String userID = await authMethods.getUserId();
      final meal = Meal(
        userID,
        _category,
        _name,
        _description,
        _timeInHours,
        _timeInMinutes,
      );
      try {
        await meal.addToFirestore();
        showSnackBar(context, "Meal added succesfully!");
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MealsList(),
          ),
        );
      } catch (e) {
        throw Exception('Error adding meal to Firestore: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: addPagesBackgroundColor,
      appBar: AppBar(
        title: Text("Add $valueChoose"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField(
                style: const TextStyle(color: inputDecorationColor, fontFamily: font1),
                dropdownColor: dropdownFieldColor,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: inputDecorationColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: inputDecorationColor),
                  ),
                ),
                value: valueChoose,
                items: listItem.map(
                        (e) =>
                        DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        )
                ).toList(),
                onChanged: (val) {
                  setState(() {
                    valueChoose = val as String;
                  });
                },
              ),
              if (valueChoose == "Full Day Meal")
                fullDayMeal()
              else if (valueChoose == "One Week Meal Plan")
                oneWeekMeal()
              else
                dayMeal()
            ],
          ),
        ),
      ),
    );
  }

  Column dayMeal () {
    return Column(
        children: [
          const SizedBox(height: 16),
          TextFormField(
            decoration: addPageInputStyle("Name"),
            cursorColor: inputDecorationColor,
            maxLength: 30,
            validator: (value) {
              if (value == null || value.isEmpty) {
                showSnackBar( context, 'Please enter the name of the meal.');
              }
              return null;
            },
            onSaved: (value) {
              _name = value ?? '';
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: addPageInputStyle("Description"),
            cursorColor: inputDecorationColor,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                showSnackBar(context, 'Please enter a description.');
              }
              return null;
            },
            onSaved: (value) {
              _description = value ?? '';
            },
          ),
          const SizedBox(height: 32),
          titleStyle("Time for preparation", questionSize),
          const SizedBox(height: 16),
          titleStyle("Minutes", questionSize*0.75),
          Slider(
            value: _timeInMinutes,
            max: 59,
            divisions: 59,
            activeColor: primaryColor,
            inactiveColor: lightLila,
            label: _timeInMinutes.round().toString(),
            onChanged: (double value) {
              setState(() {
                _timeInMinutes = value;
              });
            },
          ),
          const SizedBox(height: 16),
          titleStyle("Hours", questionSize*0.75),
          Slider(
            value: _timeInHours,
            max: 5,
            divisions: 5,
            activeColor: primaryColor,
            inactiveColor: lightLila,
            label: _timeInHours.round().toString(),
            onChanged: (double value) {
              setState(() {
                _timeInHours = value;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: mealButtonColor
            ),
            onPressed: _submitForm,
            child: Text('Save meal'),
          ),
        ]
    );

  }
  Column fullDayMeal () {
    mealChoose = "Choose meal:";
    listMeals = [
      "Choose meal:"
    ];
    return Column(
      children: [
        const SizedBox(height: 32),
        titleStyle("Breakfast", questionSize*0.9),
        dropdownChooseMenu(mealChoose, listMeals),
        const SizedBox(height: 16),
        titleStyle("Snack 1", questionSize*0.9),
        dropdownChooseMenu(mealChoose, listMeals),
        const SizedBox(height: 16),
        titleStyle("Lunch", questionSize*0.9),
        dropdownChooseMenu(mealChoose, listMeals),
        const SizedBox(height: 16),
        titleStyle("Snack 2", questionSize*0.9),
        dropdownChooseMenu(mealChoose, listMeals),
        const SizedBox(height: 16),
        titleStyle("Dinner", questionSize*0.9),
        dropdownChooseMenu(mealChoose, listMeals),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: _submitForm,
          child: const Text('Save full day meal'),
        ),
      ],
    );

  }
  Column oneWeekMeal () {
    mealChoose = "Choose plan:";
    listMeals = [
      "Choose plan:"
    ];
    return Column(
      children: [
        const SizedBox(height: 32),
        titleStyle("Monday", questionSize*0.9),
        dropdownChooseMenu(mealChoose, listMeals),
        const SizedBox(height: 16),
        titleStyle("Tuesday", questionSize*0.9),
        dropdownChooseMenu(mealChoose, listMeals),
        const SizedBox(height: 16),
        titleStyle("Wednesday", questionSize*0.9),
        dropdownChooseMenu(mealChoose, listMeals),
        const SizedBox(height: 16),
        titleStyle("Thursday", questionSize*0.9),
        dropdownChooseMenu(mealChoose, listMeals),
        const SizedBox(height: 16),
        titleStyle("Friday", questionSize*0.9),
        dropdownChooseMenu(mealChoose, listMeals),
        const SizedBox(height: 16),
        titleStyle("Saturday", questionSize*0.9),
        dropdownChooseMenu(mealChoose, listMeals),
        const SizedBox(height: 16),
        titleStyle("Sunday", questionSize*0.9),
        dropdownChooseMenu(mealChoose, listMeals),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: _submitForm,
          child: const Text('Save meal plan'),
        ),
      ],
    );
  }

  DropdownButtonFormField dropdownChooseMenu(String valueChoose, List listItems) {
    return DropdownButtonFormField(
      style: TextStyle(color: Colors.grey.shade800, fontFamily: font1),
      dropdownColor: dropdownFieldColor,
      value: valueChoose,
      items: listItems.map(
              (e) =>
              DropdownMenuItem(
                value: e,
                child: Text(e),
              )
      ).toList(),
      onChanged: (val) {
        setState(() {
          valueChoose = val as String;
        });
      },
    );
  }
}