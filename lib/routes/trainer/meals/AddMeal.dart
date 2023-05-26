import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/routes/trainer/meals/MealCategories.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:daily_gym_planner/util/showSnackBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/meal/MealServices.dart';
import '../../../util/components_theme/box.dart';

String valueChoose = "Breakfast";
List listItem = ["Breakfast", "Snack", "Lunch", "Dinner", "Full Day Meal", "One Week Meal Plan"];

List listBreakfast = [];
List listSnack = [];
List listLunch = [];
List listDinner = [];

List listOneDayPlan = ["Choose plan:"];

class AddMealPage extends StatefulWidget {
  const AddMealPage({Key? key}) : super(key: key);

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _formKey = GlobalKey<FormState>();
  String _chosenCategory = valueChoose = "Breakfast";
  String _name = '';
  String _imageUrl = '';
  String _description = '';
  double _timeInHours = 0;
  double _timeInMinutes = 0;

  String fullDayMealName = "";
  String selectedValue = "";
  String selectedBreakfast = "";
  String selectedSnack1 = "";
  String selectedLunch = "";
  String selectedDinner = "";
  String selectedSnack2 = "";

  String oneWeekPlanName = "";
  String monday = "";
  String tuesday = "";
  String wednesday = "";
  String thursday = "";
  String friday = "";
  String saturday = "";
  String sunday = "";

  File? _imageFile;

  FirebaseAuthMethods authMethods = FirebaseAuthMethods();
  FirebaseFirestore db = FirebaseFirestore.instance;

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
    else {
      Exception('Image not added!');
    }
  }

  Future _uploadImage() async {
    try {
      String userID = await authMethods.getUserId();
      final postID = DateTime.now().millisecondsSinceEpoch.toString();
      final storageReference = FirebaseStorage.instance.ref().child('$userID/meals/meal/$_chosenCategory').child("post_$postID");
      await storageReference.putFile(_imageFile!);
      final downloadUrl = await storageReference.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  void _submitMeal() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate() && _imageFile != null)
    {
      _formKey.currentState!.save();
      if (_imageFile != null)  {
        await _uploadImage();
        String userID = await authMethods.getUserId();
        final meal = Meal(
          userID,
          _chosenCategory,
          _name,
          _imageUrl,
          _description,
          _timeInHours,
          _timeInMinutes,
        );
        try {
          await meal.addMealToFirestore();
          showSnackBar(context, "Meal added successfully!");
          Navigator.pop(context);
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const CategoryList(),
            ),
          );
        } catch (e) {
          throw Exception('Error adding meal to db: $e');
        }
      } else {
        showSnackBar(context, 'Please add an image.');
        throw Exception('Image not selected!');
      }
    }
  }

  void _submitFullDayMeal() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate())
    {
      _formKey.currentState!.save();
      String userID = await authMethods.getUserId();
      final fulldaymeal = FullDayMeal(
        userID,
        fullDayMealName,
        selectedBreakfast,
        selectedSnack1,
        selectedLunch,
        selectedSnack2,
        selectedDinner
      );

      try {
        await fulldaymeal.addFullMealToFirestore();
        showSnackBar(context, "Full day meal added successfully!");
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const CategoryList(),
          ),
        );
      } catch (e) {
        throw Exception('Error adding full day meal to db: $e');
      }
    }
  }

  void _submitOneWeekMealPlan() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate())
    {
      _formKey.currentState!.save();
      String userID = await authMethods.getUserId();
      final oneWeekPlan = OneWeekMealPlan(
        userID,
        oneWeekPlanName,
        monday,
        tuesday,
        wednesday,
        thursday,
        friday,
        saturday,
        sunday
      );

      try {
        await oneWeekPlan.addOneWeekPlanToFirestore();
        showSnackBar(context, "One week meal plan added successfully!");
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const CategoryList(),
          ),
        );
      } catch (e) {
        throw Exception('Error adding one week meal plan to db: $e');
      }
    }
  }

  void getMealData(String title) async {
    listBreakfast = ["Choose breakfast:"];
    listSnack = ["Choose snack:"];
    listLunch = ["Choose lunch:"];
    listDinner = ["Choose dinner:"];
    List mealList = [];

    String userID = await authMethods.getUserId();

    db.collection("trainers/$userID/meals/meal/$title").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          mealList.add(docSnapshot.get('name'));
        }
        if (title == "Breakfast") {
          listBreakfast += mealList;
        } else if (title == "Snack") {
          listSnack += mealList;
        } else if (title == "Lunch") {
          listLunch += mealList;
        } else if (title == "Dinner") {
          listDinner += mealList;
        }
      },
      onError: (e) => Exception("Error completing: $e"),
    );
  }

  void getFullDayMealData() async {
    String userID = await authMethods.getUserId();
    listOneDayPlan = ["Choose plan:"];

    db.collection("trainers/$userID/meals/one day meal plan/One Day Meal Plan").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          listOneDayPlan.add(docSnapshot.get('name'));
        }
      },
      onError: (e) => Exception("Error completing: $e"),
    );
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
                    _chosenCategory = valueChoose;
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
    getMealData("Breakfast");
    getMealData("Snack");
    getMealData("Lunch");
    getMealData("Dinner");
    getFullDayMealData();

    return Column(
        children: [
          const SizedBox(height: 16),
          TextFormField(
            decoration: addPageInputStyle("Name"),
            cursorColor: inputDecorationColor,
            maxLength: 35,
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
          InkWell(
            onTap: () { _pickImage(); },
            child: _imageFile == null
                ? Container(
              height: 200,
              width: 400,
              color: Colors.grey[300],
              child: const Icon(Icons.add_a_photo),
            )
                : Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(_imageFile!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
            onPressed: _submitMeal,
            child: const Text('Save meal'),
          ),
          const SizedBox(height: 16),
        ]
    );

  }
  Column fullDayMeal () {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          decoration: addPageInputStyle("Name"),
          cursorColor: inputDecorationColor,
          maxLength: 25,
          validator: (value) {
            if (value == null || value.isEmpty) {
              showSnackBar( context, 'Please enter the name of the full day meal.');
            }
            return null;
          },
          onSaved: (value) {
            fullDayMealName = value ?? '';
          },
        ),
        section("Breakfast", listBreakfast[0], listBreakfast),
        section("Snack 1", listSnack[0], listSnack),
        section("Lunch", listLunch[0], listLunch),
        section("Snack 2", listSnack[0], listSnack),
        section("Dinner", listDinner[0], listDinner),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: _submitFullDayMeal,
          child: const Text('Save full day meal'),
        ),
      ],
    );
  }
  Column oneWeekMeal () {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          decoration: addPageInputStyle("Name"),
          cursorColor: inputDecorationColor,
          maxLength: 25,
          validator: (value) {
            if (value == null || value.isEmpty) {
              showSnackBar( context, 'Please enter the name of the week meal plan.');
            }
            return null;
          },
          onSaved: (value) {
            oneWeekPlanName = value ?? '';
          },
        ),
        section("Monday", listOneDayPlan[0], listOneDayPlan),
        section("Tuesday", listOneDayPlan[0], listOneDayPlan),
        section("Wednesday", listOneDayPlan[0], listOneDayPlan),
        section("Thursday", listOneDayPlan[0], listOneDayPlan),
        section("Friday", listOneDayPlan[0], listOneDayPlan),
        section("Saturday", listOneDayPlan[0], listOneDayPlan),
        section("Sunday", listOneDayPlan[0], listOneDayPlan),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: _submitOneWeekMealPlan,
          child: const Text('Save meal plan'),
        ),
      ],
    );
  }

  Column section (String title, String itemChoose, List listItems) {
    return Column(
      children: [
        const SizedBox(height: 16),
        titleStyle(title, questionSize*0.9),
        DropdownButtonFormField(
          style: TextStyle(color: Colors.grey.shade800, fontFamily: font1),
          dropdownColor: dropdownFieldColor,
          value: itemChoose,
          validator: (value) {
            if (value == null || value == "Choose breakfast:" || value == "Choose lunch:" || value == "Choose dinner:" || value == "Choose plan:") {
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
                case "Breakfast": {
                  selectedBreakfast = itemChoose;
                }
                break;
                case "Snack 1": {
                  selectedSnack1 = itemChoose;
                }
                break;
                case "Lunch": {
                  selectedLunch = itemChoose;
                }
                break;
                case "Snack 2": {
                  selectedSnack2 = itemChoose;
                }
                break;
                case "Dinner": {
                  selectedDinner = itemChoose;
                }
                break;
                case "Monday": {
                  monday = itemChoose;
                }
                break;
                case "Tuesday": {
                  tuesday = itemChoose;
                }
                break;
                case "Wednesday": {
                  wednesday = itemChoose;
                }
                break;
                case "Thursday": {
                  thursday = itemChoose;
                }
                break;
                case "Friday": {
                  friday = itemChoose;
                }
                break;
                case "Saturday": {
                  saturday = itemChoose;
                }
                break;
                case "Sunday": {
                  sunday = itemChoose;
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