import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:daily_gym_planner/util/showSnackBar.dart';
import 'package:flutter/material.dart';

import '../../services/MealServices.dart';

String valueChoose = "Breakfast";
List listItem = [
  "Breakfast", "Snack", "Lunch", "Dinner"
];
double _currentSliderValue1 = 0;
double _currentSliderValue2 = 0;

class AddMealPage extends StatefulWidget {
  AddMealPage({Key? key}) : super(key: key);

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _formKey = GlobalKey<FormState>();
  String _category = valueChoose;
  String _name = '';
  String _description = '';
  double _timeInHours = _currentSliderValue2;
  double _timeInMinutes = _currentSliderValue1;

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
      } catch (e) {
        throw Exception('Error adding meal to Firestore: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mealPagesColor,
      appBar: AppBar(
        title: Text('Add Meal'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: DropdownButtonFormField(
                  style: TextStyle(color: Colors.grey.shade800, fontFamily: font1),
                  dropdownColor: dropdownFieldColor,
                  value: valueChoose,
                  items: listItem.map(
                          (e) =>
                          DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          )
                  ).toList(),
                  onChanged: (val) {
                    setState(() {
                      valueChoose = val as String;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
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
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
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
              SizedBox(height: 32),
              Text(
                "Time for preparation",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: questionSize,
                  fontFamily: font1,
                )
              ),
              SizedBox(height: 16),
              Text(
                  "Minutes",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: questionSize*0.75,
                    fontFamily: font1,
                  )
              ),
              Slider(
                value: _currentSliderValue1,
                max: 59,
                divisions: 59,
                activeColor: primaryColor,
                label: _currentSliderValue1.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue1 = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                  "Hours",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: questionSize*0.75,
                    fontFamily: font1,
                  )
              ),
              Slider(
                value: _currentSliderValue2,
                max: 5,
                divisions: 5,
                activeColor: primaryColor,
                label: _currentSliderValue2.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue2 = value;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: mealButtonColor
                ),
                onPressed: _submitForm,
                child: Text('Save meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
