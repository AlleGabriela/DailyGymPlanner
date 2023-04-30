import 'package:daily_gym_planner/routes/trainer/WorkoutListPage.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:daily_gym_planner/util/showSnackBar.dart';
import 'package:flutter/material.dart';

import '../../util/components_theme/box.dart';

String valueChoose = "Upper Body";
String upperValueChoose = "Abs";
String lowerValueChoose = "Calves";
String nrSeriesChoose = "1 series";
String nrRepsChoose = "1 reps";
List listItem = [ "Upper Body", "Lower Body", "Upper Body Muscle Group", "Lower Body Muscle Group", "One Day Workout", "One Week Workout Plan" ];
List listUpperLowerBody = ["Upper Body", "Lower Body"];
List upperBodyItems = [ "Abs", "Back", "Biceps", "Chest", "Shoulders", "Traps", "Triceps"];
List lowerBodyItems = [ "Calves", "Hamstrings", "Glutes", "Quads"];
List nrSeries = [ "1 series", "2 series", "3 series", "4 series", "5 series", "6 series", "7 series", "8 series", "9 series", "10 series"];
List nrReps =  [ "1 reps", "2 reps", "3 reps", "4 reps", "5 reps", "6 reps", "7 reps", "8 reps", "9 reps", "10 reps", "11 reps", "12 reps", "13 reps", "14 reps", "15 reps", "16 reps", "17 reps", "18 reps", "19 reps", "20 reps"];
List exerciseUpperBody = [ ];
List exerciseLowerBody = [ ];
List exerciseLowerUpperBody = [];
List oneDayWorkoutExercise = [];


String workoutChoose = "";
List listWorkouts = [ ];

class AddWorkoutPage extends StatefulWidget {
  const AddWorkoutPage({Key? key}) : super(key: key);

  @override
  _AddWorkoutPageState createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _category = valueChoose = "Upper Body";
  String _UpperBodySubcategory = upperValueChoose = "Abs";
  String _LowerBodySubcategory = lowerValueChoose = "Calves";
  String _name = '';
  FirebaseAuthMethods authMethods = FirebaseAuthMethods();

  String selectedBodyPart = 'Chest';
  String selectedMuscleGroup = 'Upper Chest';
  String selectedPlan = 'Strength';

  final Map<String, List<String>> muscleGroups = {
    'Chest': ['Upper Chest', 'Lower Chest'],
    'Back': ['Upper Back', 'Lower Back'],
    'Shoulders': ['Front Shoulders', 'Side Shoulders', 'Rear Shoulders'],
  };

  final Map<String, List<String>> exercisePlans = {
    'Strength': ['3x5', '5x5', '3x8'],
    'Hypertrophy': ['3x10', '4x10', '3x12'],
    'Endurance': ['3x15', '4x15', '3x20'],
  };

  void _submitForm() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate())
    {
      _formKey.currentState!.save();
      String userID = await authMethods.getUserId();
      // final workout = Workout(
      //   userID,
      //   _category,
      //   _name,
      //   _description,
      // );
      try {
        // await workout.addToFirestore();
        showSnackBar(context, "Workout added succesfully!");
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => WorkoutList(),
          ),
        );
      } catch (e) {
        throw Exception('Error adding workout to Firestore: $e');
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
                    exerciseLowerUpperBody.clear();
                    oneDayWorkoutExercise.clear();
                  });
                },
              ),
              if (valueChoose == "Upper Body Muscle Group" || valueChoose == "Lower Body Muscle Group")
                muscleGroup(valueChoose)
              else if (valueChoose == "One Day Workout")
                oneDayWorkout()
              else if ( valueChoose == "One Week Workout Plan")
                oneWeekWorkout()
              else
                workoutExercise(valueChoose)
            ],
          ),
        ),
      ),
    );
  }

  Column workoutExercise (String listType) {
    if( listType == "Upper Body") {
      workoutChoose = _UpperBodySubcategory;
      listWorkouts = upperBodyItems;
    }  else {
      workoutChoose = _LowerBodySubcategory;
      listWorkouts = lowerBodyItems;
    }
    return Column(
      children: [
        const SizedBox(height: 16),
        dropdownChooseMenu(workoutChoose, listWorkouts),
        const SizedBox(height: 16),
        TextFormField(
          decoration: addPageInputStyle("Name"),
          cursorColor: inputDecorationColor,
          maxLength: 30,
          validator: (value) {
            if (value == null || value.isEmpty) {
              showSnackBar( context, 'Please enter the name of the exercise.');
            }
            return null;
          },
          onSaved: (value) {
            _name = value ?? '';
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: _submitForm,
          child: Text('Save exercise'),
        ),
      ],
    );
  }

  Column muscleGroup( String listType) {
    if( listType == "Upper Body Muscle Group") {
      workoutChoose = _UpperBodySubcategory;
      listWorkouts = upperBodyItems;
    }  else {
      workoutChoose = _LowerBodySubcategory;
      listWorkouts = lowerBodyItems;
    }
    return Column(
      children: [
        const SizedBox(height: 16),
        dropdownChooseMenu(workoutChoose, listWorkouts),
        Row(
          children: [
            Expanded(child: dropdownChooseMenu(workoutChoose, listWorkouts)),
            Expanded(child: dropdownChooseMenu(nrSeriesChoose, nrSeries)),
            Expanded(child: dropdownChooseMenu(nrRepsChoose, nrReps)),
            GestureDetector(
              onTap: addDropdownItem,
              child: Icon(Icons.add_circle),
            ),
          ],
        ),
        for (var item in exerciseLowerUpperBody)
          Row(
              children: [
                  const SizedBox(height: 16),
                  Expanded(child: dropdownChooseMenu(workoutChoose, listWorkouts)),
                  Expanded(child: dropdownChooseMenu(nrSeriesChoose, nrSeries)),
                  Expanded(child: dropdownChooseMenu(nrRepsChoose, nrReps)),
                  GestureDetector(
                    onTap: addDropdownItem,
                    child: Icon(Icons.add_circle),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        final index = exerciseLowerUpperBody.indexOf(item);
                        if (index != -1) {
                          exerciseLowerUpperBody.removeAt(index);
                        }
                      });
                    },
                  child: Icon(Icons.remove_circle),
                ),
              ],
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: _submitForm,
          child: Text('Save group'),
        ),
      ],
    );
  }

  Column oneDayWorkout () {
    return Column(
      children: [
        const SizedBox(height: 32),
        titleStyle("Add groups of exercises", questionSize*0.9),
        const SizedBox(height: 16),
        parentChildDropdown(
          title: "Select Body Part",
          titleSize: questionSize * 0.7,
          selectedValue: selectedBodyPart,
          onChanged: (value) {
            setState(() {
              selectedBodyPart = value!;
              selectedMuscleGroup = muscleGroups[selectedBodyPart]![0];
              selectedPlan = exercisePlans.keys.first;
            });
          },
          dropdownItems: muscleGroups.keys.toList(),
        ),
        parentChildDropdown(
          title: "Select Muscle Group",
          titleSize: questionSize * 0.7,
          selectedValue: selectedMuscleGroup,
          onChanged: (value) {
            setState(() {
              selectedMuscleGroup = value!;
            });
          },
          dropdownItems: muscleGroups[selectedBodyPart]!,
        ),
        parentChildDropdown(
          title: "Select Plan",
          titleSize: questionSize * 0.7,
          selectedValue: selectedPlan,
          onChanged: (value) {
            setState(() {
              selectedPlan = value!;
            });
          },
          dropdownItems: exercisePlans.keys.toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleStyle("Add another exercise group:", titleSize*0.3),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: addGroupOfExercise,
                    child: Icon(Icons.add_circle),
                  ),
                ],
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),

        for (var item in oneDayWorkoutExercise)
          Column(
            children: [
              const SizedBox(height: 32),
              parentChildDropdown(
                title: "Select Body Part",
                titleSize: questionSize * 0.7,
                selectedValue: selectedBodyPart,
                onChanged: (value) {
                  setState(() {
                    selectedBodyPart = value!;
                    selectedMuscleGroup = muscleGroups[selectedBodyPart]![0];
                    selectedPlan = exercisePlans.keys.first;
                  });
                },
                dropdownItems: muscleGroups.keys.toList(),
              ),
              parentChildDropdown(
                title: "Select Muscle Group",
                titleSize: questionSize * 0.7,
                selectedValue: selectedMuscleGroup,
                onChanged: (value) {
                  setState(() {
                    selectedMuscleGroup = value!;
                  });
                },
                dropdownItems: muscleGroups[selectedBodyPart]!,
              ),
              parentChildDropdown(
                title: "Select Plan",
                titleSize: questionSize * 0.7,
                selectedValue: selectedPlan,
                onChanged: (value) {
                  setState(() {
                    selectedPlan = value!;
                  });
                },
                dropdownItems: exercisePlans.keys.toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  titleStyle("Add or delete exercise group:", titleSize*0.3),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: addGroupOfExercise,
                          child: Icon(Icons.add_circle),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              final index = oneDayWorkoutExercise.indexOf(item);
                              if (index != -1) {
                                oneDayWorkoutExercise.removeAt(index);
                              }
                            });
                          },
                          child: Icon(Icons.remove_circle),
                        ),
                      ],
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ],
          ),

        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: _submitForm,
          child: Text('Save workout'),
        ),
      ],
    );

  }

  Column oneWeekWorkout () {
    // TODO: add from database the list and the implicit value is Pause
    workoutChoose = _LowerBodySubcategory;
    listWorkouts = lowerBodyItems;
    return Column(
      children: [
        const SizedBox(height: 32),
        titleStyle("Monday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts),
        const SizedBox(height: 16),
        titleStyle("Tuesday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts),
        const SizedBox(height: 16),
        titleStyle("Wednesday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts),
        const SizedBox(height: 16),
        titleStyle("Thursday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts),
        const SizedBox(height: 16),
        titleStyle("Friday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts),
        const SizedBox(height: 16),
        titleStyle("Saturday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts),
        const SizedBox(height: 16),
        titleStyle("Sunday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: _submitForm,
          child: const Text('Save workout plan'),
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

  void addDropdownItem() {
    setState(() {
      exerciseLowerUpperBody.add(
        DropdownMenuItem(
          child: Row(
            children: [
              Expanded(child: dropdownChooseMenu(workoutChoose, listWorkouts)),
              Expanded(child: dropdownChooseMenu(nrSeriesChoose, nrSeries)),
              Expanded(child: dropdownChooseMenu(nrRepsChoose, nrReps)),
            ],
          ),
        ),
      );
    });
  }

  void addGroupOfExercise() {
    setState(() {
      oneDayWorkoutExercise.add(
        DropdownMenuItem(
          child: Row(
            children: [
              parentChildDropdown(
                title: "Select Body Part",
                titleSize: questionSize * 0.7,
                selectedValue: selectedBodyPart,
                onChanged: (value) {
                  setState(() {
                    selectedBodyPart = value!;
                    selectedMuscleGroup = muscleGroups[selectedBodyPart]![0];
                    selectedPlan = exercisePlans.keys.first;
                  });
                },
                dropdownItems: muscleGroups.keys.toList(),
              ),
              parentChildDropdown(
                title: "Select Muscle Group",
                titleSize: questionSize * 0.7,
                selectedValue: selectedMuscleGroup,
                onChanged: (value) {
                  setState(() {
                    selectedMuscleGroup = value!;
                  });
                },
                dropdownItems: muscleGroups[selectedBodyPart]!,
              ),
              parentChildDropdown(
                title: "Select Plan",
                titleSize: questionSize * 0.7,
                selectedValue: selectedPlan,
                onChanged: (value) {
                  setState(() {
                    selectedPlan = value!;
                  });
                },
                dropdownItems: exercisePlans.keys.toList(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget parentChildDropdown({
    required String title,
    required double titleSize,
    required String selectedValue,
    required Function(String?) onChanged,
    required List<String> dropdownItems,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: titleStyle(title, titleSize)),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedValue,
                onChanged: onChanged,
                items: dropdownItems.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

}
