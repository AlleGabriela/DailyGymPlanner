import 'package:daily_gym_planner/routes/trainer/Workout/WorkoutListPage.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:daily_gym_planner/util/showSnackBar.dart';
import 'package:flutter/material.dart';

import '../../../services/workout/MuscleGroupExerciseServices.dart';
import '../../../services/workout/WorkoutServices.dart';
import '../../../util/components_theme/box.dart';

List<String> listItem = [ "Choose category", "Upper Body", "Lower Body", "Upper Body Muscle Group", "Lower Body Muscle Group", "One Day Workout", "One Week Workout Plan" ];
List<String> listUpperLowerBody = ["Upper Body", "Lower Body"];
List<String> upperBodyItems = [ "Choose", "Abs", "Back", "Biceps", "Chest", "Shoulders", "Traps", "Triceps"];
List<String> lowerBodyItems = [ "Choose:", "Calves", "Hamstrings", "Glutes", "Quads"];
List<String> nrSeries = [ "0 series", "1 series", "2 series", "3 series", "4 series", "5 series", "6 series", "7 series", "8 series", "9 series", "10 series"];
List<String> nrReps =  [ "0 reps", "1 reps", "2 reps", "3 reps", "4 reps", "5 reps", "6 reps", "7 reps", "8 reps", "9 reps", "10 reps", "11 reps", "12 reps", "13 reps", "14 reps", "15 reps", "16 reps", "17 reps", "18 reps", "19 reps", "20 reps"];

List exerciseUpperBody = [];
List exerciseLowerBody = [];
List oneDayWorkoutExercise = [];

class AddWorkoutPage extends StatefulWidget {
  const AddWorkoutPage({Key? key}) : super(key: key);

  @override
  _AddWorkoutPageState createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _category = "";
  String _subcategory = "";
  String _name = '';
  String _UpperBodySubcategory  = "Choose";
  String _LowerBodySubcategory  = "Choose:";
  String valueChoose = "Choose category";
  String nrSeriesChoose = "0 series";
  String nrRepsChoose = "0 reps";

  String _nameMuscleGroup = "";
  List<Map<String, dynamic>> exerciseLowerUpperBody = [];

  String workoutChoose = "";
  List listWorkouts = [];

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
  final key = ValueKey(DateTime.now().toString());

  void _addExercise() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate())
    {
      _formKey.currentState!.save();
      String userID = await authMethods.getUserId();
      final workout = Workout(
        userID,
        _category,
        _subcategory,
        _name,
      );
      try {
        await workout.addWorkoutToFirestore();
        showSnackBar(context, "Exercise added succesfully!");
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

  void _addMuscleGroup() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate())
    {
      _formKey.currentState!.save();
      final data = exerciseLowerUpperBody.map((exerciseLowerUpperBody) => {
        'name': exerciseLowerUpperBody["Exercise name"],
        'nrSeries': exerciseLowerUpperBody["Series number"],
        'nrReps': exerciseLowerUpperBody["Reps number"],
      }).toList();
      String userID = await authMethods.getUserId();
      final muscleGroup = MuscleGroupExercise(
        userID,
        _category,
        _subcategory,
        _nameMuscleGroup,
        data,
      );
      try {
        await muscleGroup.addMuscleGroupExerciseToFirestore();
        showSnackBar(context, "Muscle group exercise added succesfully!");
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => WorkoutList(),
          ),
        );
      } catch (e) {
        throw Exception('Error adding muscle group exercise to Firestore: $e');
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
                    exerciseLowerUpperBody.add({});
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
    _category = listType;
    return Column(
      children: [
        const SizedBox(height: 16),
        dropdownChooseMenu(workoutChoose, listWorkouts, listType),
        const SizedBox(height: 16),
        TextFormField(
          decoration: addPageInputStyle("Name"),
          cursorColor: inputDecorationColor,
          maxLength: 35,
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
          onPressed: _addExercise,
          child: Text('Save exercise'),
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
          onPressed: _addExercise,
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
        dropdownChooseMenu(workoutChoose, listWorkouts, "Monday"),
        const SizedBox(height: 16),
        titleStyle("Tuesday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts, "Tuesday"),
        const SizedBox(height: 16),
        titleStyle("Wednesday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts, "Wednesday"),
        const SizedBox(height: 16),
        titleStyle("Thursday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts, "Thursday"),
        const SizedBox(height: 16),
        titleStyle("Friday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts, "Friday"),
        const SizedBox(height: 16),
        titleStyle("Saturday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts, "Saturday"),
        const SizedBox(height: 16),
        titleStyle("Sunday", questionSize*0.9),
        dropdownChooseMenu(workoutChoose, listWorkouts, "Sunday"),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: _addExercise,
          child: const Text('Save workout plan'),
        ),
      ],
    );
  }

  DropdownButtonFormField dropdownChooseMenu(String valueChoose, List listItems, String title) {
    return DropdownButtonFormField(
      style: TextStyle(color: Colors.grey.shade800, fontFamily: font1),
      dropdownColor: dropdownFieldColor,
      value: valueChoose,
      validator: (value) {
        if (value == null || value == "Choose" || value == "Choose:" || value == "Choose category" || value == "0 series" || value == "0 reps") {
          showSnackBar( context, 'Please select an option.');
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
          valueChoose = val as String;
          switch(title) {
            case "Upper Body":
              {
                _subcategory = valueChoose;
                break;
              }
            case "Lower Body":
              {
                _subcategory = valueChoose;
                break;
              }
            case "Upper Body Muscle Group":
              {
                _subcategory = valueChoose;
                break;
              }
            case "Muscle Group Subcategory":
              {
                _subcategory = valueChoose;
                break;
              }
            case "Monday":
              {
                break;
              }
            case "Tuesday":
              {
                break;
              }
            case "Wednesday":
              {
                break;
              }
            case "Thursday":
              {
                break;
              }
            case "Friday":
              {
                break;
              }
            case "Saturday":
              {
                break;
              }
            case "Sunday":
              {
                break;
              }
            default:
              {
                _subcategory = valueChoose;
                break;
              }
          }
        });
      },
    );
  }


  /* Group Exercise functions */
  void _addNewLine() {
    setState(() {
      exerciseLowerUpperBody.add({});
    });
  }

  void _deleteLine(int index) {
    setState(() {
      exerciseLowerUpperBody.removeAt(index);
    });
  }

  Widget _buildDropdown(int index, String dropdownLabel, List<String> dropdownItems) {
    return DropdownButtonFormField<String>(
      value: exerciseLowerUpperBody[index][dropdownLabel],
      items: dropdownItems
          .map((value) => DropdownMenuItem(
        child: Text(value),
        value: value,
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          exerciseLowerUpperBody[index][dropdownLabel] = value;
        });
      },
      decoration: InputDecoration(
        labelText: dropdownLabel,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLine(int index) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              _buildDropdown(index, "Exercise name", upperBodyItems),
              SizedBox(height: 16),
              _buildDropdown(index, "Series number", nrSeries),
              SizedBox(height: 16),
              _buildDropdown(index, "Reps number", nrReps),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: index == exerciseLowerUpperBody.length - 1 &&
              exerciseLowerUpperBody[index]["Exercise name"] != null && exerciseLowerUpperBody[index]["Exercise name"] != "Choose" &&
              exerciseLowerUpperBody[index]["Series number"] != null && exerciseLowerUpperBody[index]["Series number"] != "0 series" &&
              exerciseLowerUpperBody[index]["Reps number"] != null   && exerciseLowerUpperBody[index]["Reps number"] != "0 reps"
              ? _addNewLine
              : null,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            if (exerciseLowerUpperBody.length > 1) {
              _deleteLine(index);
            }
          },
        ),
      ],
    );
  }

  Column muscleGroup( String listType) {
    if( listType == "Upper Body Muscle Group") {
      workoutChoose = _UpperBodySubcategory;
      listWorkouts = upperBodyItems;
      _category = "Upper Body";
    }  else {
      workoutChoose = _LowerBodySubcategory;
      listWorkouts = lowerBodyItems;
      _category = "Lower Body";
    }
    return Column(
      children: [
        const SizedBox(height: 16),
        dropdownChooseMenu(workoutChoose, listWorkouts, listType),
        const SizedBox(height: 16),
        TextFormField(
          decoration: addPageInputStyle("Name"),
          cursorColor: inputDecorationColor,
          maxLength: 50,
          validator: (value) {
            if (value == null || value.isEmpty) {
              showSnackBar( context, 'Please enter the name of the group.');
            }
            return null;
          },
          onSaved: (value) {
            _nameMuscleGroup = value ?? '';
          },
        ),
        for (var i = 0; i < exerciseLowerUpperBody.length; i++)
          _buildLine(i),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: () {
            bool allValuesNonNull = true;
            for (Map<String, dynamic> row in exerciseLowerUpperBody) {
              if (row['Exercise name'] == null || row['Exercise name'] == "Choose" ||
                  row['Series number'] == null || row['Exercise name'] == "0 series" ||
                  row['Reps number'] == null || row['Exercise name'] == "0 reps") {
                allValuesNonNull = false;
                break;
              }
            }
            if (allValuesNonNull) {
              _addMuscleGroup();
            } else {
              showSnackBar(context, "Please select a valid choice");
            }
          },

          child: Text('Save group'),
        ),
      ],
    );
  }
  /* End group of exercise functions */


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
