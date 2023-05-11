import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/routes/trainer/Workout/WorkoutListPage.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:daily_gym_planner/services/workout/OneDayWorkoutServices.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:daily_gym_planner/util/showSnackBar.dart';
import 'package:flutter/material.dart';

import '../../../services/workout/MuscleGroupExerciseServices.dart';
import '../../../services/workout/WorkoutServices.dart';
import '../../../util/components_theme/box.dart';

List<String> listItem = [ "Choose category", "Upper Body", "Lower Body", "Upper Body Muscle Group", "Lower Body Muscle Group", "One Day Workout", "One Week Workout Plan" ];
List<String> upperBodyItems = [ "Choose", "Abs", "Back", "Biceps", "Chest", "Shoulders", "Traps", "Triceps"];
List<String> lowerBodyItems = [ "Choose:", "Calves", "Hamstrings", "Glutes", "Quads"];

class AddWorkoutPage extends StatefulWidget {
  const AddWorkoutPage({Key? key}) : super(key: key);

  @override
  _AddWorkoutPageState createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _category = "";
  String _subcategory = "";
  String _nameSimpleExercise = '';
  String valueChoose = "Choose category";
  bool isCategorySelected = false;

  /** Group of Exercise Variables **/
  String _nameMuscleGroup = "";
  List<Map<String, dynamic>> exerciseLowerUpperBody = [];
  List<String> exerciseNames = [];
  List<String> exerciseAbs = [];
  List<String> exerciseBack = [];
  List<String> exerciseBiceps = [];
  List<String> exerciseChest= [];
  List<String> exerciseShoulders = [];
  List<String> exerciseTraps = [];
  List<String> exerciseTriceps = [];
  List<String> exerciseCalves = [];
  List<String> exerciseHamstrings = [];
  List<String> exerciseGlutes = [];
  List<String> exerciseQuads = [];
  /** End Group of Exercise Variables **/

  String _nameOneDayWorkout = "";
  List<String> oneDayWorkoutWorkouts = [];
  List<String> muscleGroupWorkoutsNames = [];

  String workoutChoose = "";
  List listWorkouts = [];

  FirebaseAuthMethods authMethods = FirebaseAuthMethods();
  FirebaseFirestore db = FirebaseFirestore.instance;

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
        _nameSimpleExercise,
      );
      try {
        await workout.addWorkoutToFirestore();
        showSnackBar(context, "Exercise added succesfully!");
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const WorkoutList(),
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
            builder: (BuildContext context) => const WorkoutList(),
          ),
        );
      } catch (e) {
        throw Exception('Error adding muscle group exercise to Firestore: $e');
      }
    }
  }

  void _addOneDayWorkout() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate())
    {
      _formKey.currentState!.save();
      String userID = await authMethods.getUserId();
      final oneDayWorkoutInstance = OneDayWorkout(
        userID,
        _nameOneDayWorkout,
        oneDayWorkoutWorkouts,
      );
      try {
        await oneDayWorkoutInstance.addOneDayWorkoutToFirestore();
        showSnackBar(context, "One Day Workout added succesfully!");
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const WorkoutList(),
          ),
        );
      } catch (e) {
        throw Exception('Error adding one day workout to Firestore: $e');
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
                    isCategorySelected = true;
                    exerciseLowerUpperBody.clear();
                    exerciseLowerUpperBody.add({});
                    oneDayWorkoutExercise.clear();
                    oneDayWorkoutExercise.add({});
                  });
                },
              ),
              if ( (valueChoose == "Upper Body Muscle Group" || valueChoose == "Lower Body Muscle Group") && isCategorySelected == true)
                muscleGroup(valueChoose)
              else if (valueChoose == "One Day Workout" && isCategorySelected == true)
                oneDayWorkout()
              else if ( valueChoose == "One Week Workout Plan" && isCategorySelected == true)
                  oneWeekWorkout()
                else if(isCategorySelected == true)
                  workoutExercise(valueChoose)
            ],
          ),
        ),
      ),
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
          exerciseLowerUpperBody.clear();
          exerciseLowerUpperBody.add({});
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
            case "Lower Body Muscle Group":
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


  /** Single exercise functions **/
  Column workoutExercise (String listType) {
    final String _upperBodySubcategory  = "Choose";
    final String _lowerBodySubcategory  = "Choose:";

    if( listType == "Upper Body") {
      workoutChoose = _upperBodySubcategory;
      listWorkouts = upperBodyItems;
    }  else {
      workoutChoose = _lowerBodySubcategory;
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
          maxLength: 50,
          validator: (value) {
            if (value == null || value.isEmpty) {
              showSnackBar( context, 'Please enter the name of the exercise.');
            }
            return null;
          },
          onSaved: (value) {
            _nameSimpleExercise = value ?? '';
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: _addExercise,
          child: const Text('Save exercise'),
        ),
      ],
    );
  }

  /** End Single exercise functions **/

  /** Group Exercise functions  **/
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
      style: TextStyle(color: Colors.grey.shade800, fontFamily: font1),
      dropdownColor: dropdownFieldColor,
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
        border: const OutlineInputBorder(),
      ),
      isExpanded: true,
    );
  }

  Widget _buildLine(int index, String subcategoryExercise, List<String> secondList, List<String> thirdList) {

    List<String> firstList = [];
    firstList.clear();
    if (subcategoryExercise == 'Abs') {
      firstList += exerciseAbs;
    } else if (subcategoryExercise == 'Back') {
      firstList += exerciseBack;
    } else if (subcategoryExercise == 'Biceps') {
      firstList += exerciseBiceps;
    } else if (subcategoryExercise == 'Chest') {
      firstList += exerciseChest;
    } else if (subcategoryExercise == 'Shoulders') {
      firstList += exerciseShoulders;
    } else if (subcategoryExercise == 'Traps') {
      firstList += exerciseTraps;
    } else if (subcategoryExercise == 'Triceps') {
      firstList += exerciseTriceps;
    } else if (subcategoryExercise == 'Calves') {
      firstList += exerciseCalves;
    } else if (subcategoryExercise == 'Hamstrings') {
      firstList += exerciseHamstrings;
    } else if (subcategoryExercise == 'Glutes') {
      firstList += exerciseGlutes;
    } else if (subcategoryExercise == 'Quads') {
      firstList += exerciseQuads;
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              _buildDropdown(index, "Exercise name", firstList),
              const SizedBox(height: 16),
              _buildDropdown(index, "Series number", secondList),
              const SizedBox(height: 16),
              _buildDropdown(index, "Reps number", thirdList),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: index == exerciseLowerUpperBody.length - 1 &&
              exerciseLowerUpperBody[index]["Exercise name"] != null && exerciseLowerUpperBody[index]["Exercise name"] != "Choose" &&
              exerciseLowerUpperBody[index]["Series number"] != null && exerciseLowerUpperBody[index]["Series number"] != "0 series" &&
              exerciseLowerUpperBody[index]["Reps number"] != null   && exerciseLowerUpperBody[index]["Reps number"] != "0 reps"
              ? _addNewLine
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            if (exerciseLowerUpperBody.length > 1) {
              _deleteLine(index);
            }
          },
        ),
      ],
    );
  }

  void getExerciseNames(String category, String subcategory) async {
    List<String> names = await getExercisesName(category, subcategory);
    setState(() {
      exerciseNames.clear();
      exerciseNames = names;
    });
    if (subcategory == 'Abs') {
      exerciseAbs.clear();
      exerciseAbs += exerciseNames;
    } else if (subcategory == 'Back') {
      exerciseBack.clear();
      exerciseBack += exerciseNames;
    } else if (subcategory == 'Biceps') {
      exerciseBiceps.clear();
      exerciseBiceps += exerciseNames;
    } else if (subcategory == 'Chest') {
      exerciseChest.clear();
      exerciseChest += exerciseNames;
    } else if (subcategory == 'Shoulders') {
      exerciseShoulders.clear();
      exerciseShoulders += exerciseNames;
    } else if (subcategory == 'Traps') {
      exerciseTraps.clear();
      exerciseTraps += exerciseNames;
    } else if (subcategory == 'Triceps') {
      exerciseTriceps.clear();
      exerciseTriceps += exerciseNames;
    } else if (subcategory == 'Calves') {
      exerciseCalves.clear();
      exerciseCalves += exerciseNames;
    } else if (subcategory == 'Hamstrings') {
      exerciseHamstrings.clear();
      exerciseHamstrings += exerciseNames;
    } else if (subcategory == 'Glutes') {
      exerciseGlutes.clear();
      exerciseGlutes += exerciseNames;
    } else if (subcategory == 'Quads') {
      exerciseQuads.clear();
      exerciseQuads += exerciseNames;
    }
  }

  Column muscleGroup( String listType) {
    final String _upperBodySubcategory  = "Choose";
    final String _lowerBodySubcategory  = "Choose:";

    List<String> nrSeries = [ "0 series", "1 series", "2 series", "3 series", "4 series", "5 series", "6 series", "7 series", "8 series", "9 series", "10 series"];
    List<String> nrReps =  [ "0 reps", "1 reps", "2 reps", "3 reps", "4 reps", "5 reps", "6 reps", "7 reps", "8 reps", "9 reps", "10 reps", "11 reps", "12 reps", "13 reps", "14 reps", "15 reps", "16 reps", "17 reps", "18 reps", "19 reps", "20 reps"];

    if( listType == "Upper Body Muscle Group") {
      workoutChoose = _upperBodySubcategory;
      listWorkouts = upperBodyItems;
      _category = "Upper Body";
      getExerciseNames(_category, 'Abs');
      getExerciseNames(_category, 'Back');
      getExerciseNames(_category, 'Biceps');
      getExerciseNames(_category, 'Chest');
      getExerciseNames(_category, 'Shoulders');
      getExerciseNames(_category, 'Traps');
      getExerciseNames(_category, 'Triceps');
    }  else {
      workoutChoose = _lowerBodySubcategory;
      listWorkouts = lowerBodyItems;
      _category = "Lower Body";
      getExerciseNames(_category, 'Calves');
      getExerciseNames(_category, 'Hamstrings');
      getExerciseNames(_category, 'Glutes');
      getExerciseNames(_category, 'Quads');
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
            _buildLine(i, _subcategory, nrSeries, nrReps),
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

          child: const Text('Save group'),
        ),
      ],
    );
  }
  /** End group of exercise functions **/

  /** One Day Workout functions **/

  List<Map<String, dynamic>> oneDayWorkoutExercise = [];

  final Map<String, List<String>> muscleGroups = {
    'None selected': ['Select'],
    'Upper Body': ['Abs', 'Back', 'Biceps', 'Chest', 'Shoulders', 'Traps', 'Triceps'],
    'Lower Body': ['Calves', 'Hamstrings', 'Glutes', 'Quads'],
  };

  final Map<String, List<String>> exercisePlans = {
    'Select': ['Select'],
    'Abs': [],
    'Back': [],
    'Biceps': [],
    'Chest': [],
    'Shoulders': [],
    'Traps': [],
    'Triceps': [],
    'Calves': [],
    'Hamstrings': [],
    'Glutes': [],
    'Quads': [],
  };

  void _addNewWorkoutLine() {
    setState(() {
      oneDayWorkoutExercise.add({});
    });
  }

  void _deleteWorkoutLine(int index) {
    setState(() {
      oneDayWorkoutExercise.removeAt(index);
    });
  }

  void getMuscleGroupNames(String category, String subcategory) async {
    List<String> names = await getMuscleGroupWorkoutsName(category, subcategory);
    setState(() {
      muscleGroupWorkoutsNames.clear();
      muscleGroupWorkoutsNames = names;
    });
    if (subcategory == 'Abs') {
      exercisePlans['Abs']?.clear();
      exercisePlans['Abs']?.addAll(muscleGroupWorkoutsNames);
    } else if (subcategory == 'Back') {
      exercisePlans['Back']?.clear();
      exercisePlans['Back']?.addAll(muscleGroupWorkoutsNames);
    } else if (subcategory == 'Biceps') {
      exercisePlans['Biceps']?.clear();
      exercisePlans['Biceps']?.addAll(muscleGroupWorkoutsNames);
    } else if (subcategory == 'Chest') {
      exercisePlans['Chest']?.clear();
      exercisePlans['Chest']?.addAll(muscleGroupWorkoutsNames);
    } else if (subcategory == 'Shoulders') {
      exercisePlans['Shoulders']?.clear();
      exercisePlans['Shoulders']?.addAll(muscleGroupWorkoutsNames);
    } else if (subcategory == 'Traps') {
      exercisePlans['Traps']?.clear();
      exercisePlans['Traps']?.addAll(muscleGroupWorkoutsNames);
    } else if (subcategory == 'Triceps') {
      exercisePlans['Triceps']?.clear();
      exercisePlans['Triceps']?.addAll(muscleGroupWorkoutsNames);
    } else if (subcategory == 'Calves') {
      exercisePlans['Calves']?.clear();
      exercisePlans['Calves']?.addAll(muscleGroupWorkoutsNames);
    } else if (subcategory == 'Hamstrings') {
      exercisePlans['Hamstrings']?.clear();
      exercisePlans['Hamstrings']?.addAll(muscleGroupWorkoutsNames);
    } else if (subcategory == 'Glutes') {
      exercisePlans['Glutes']?.clear();
      exercisePlans['Glutes']?.addAll(muscleGroupWorkoutsNames);
    } else if (subcategory == 'Quads') {
      exercisePlans['Quads']?.clear();
      exercisePlans['Quads']?.addAll(muscleGroupWorkoutsNames);
    }
  }

  Widget buildGroupOfExerciseLine(int index, String selectedBodyPart, String selectedMuscleGroup, String selectedPlan) {
    List<String> secondList = [];
    List<String> thirdList = [];
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: titleStyle("Select Body Part", questionSize * 0.7)),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedBodyPart,
                onChanged: (value) {
                  setState(() {
                    selectedBodyPart = value!;
                    selectedMuscleGroup = muscleGroups[selectedBodyPart]![0];
                    selectedPlan = exercisePlans.keys.first;
                    oneDayWorkoutExercise[index]["Body Part"] = selectedBodyPart;
                    for(int i=0; i<muscleGroups.length; i++)
                      if(muscleGroups[i] == selectedBodyPart)
                        secondList = muscleGroups[i]!;
                  });
                },
                items: muscleGroups.keys.toList().map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: titleStyle("Select Muscle Group", questionSize * 0.7)),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedBodyPart,
                onChanged: (value) {
                  setState(() {
                    selectedMuscleGroup = value!;
                    oneDayWorkoutExercise[index]["Muscle Group"] = selectedMuscleGroup;
                    for(int i=0; i<exercisePlans.length; i++) {
                      if(exercisePlans[i] == selectedMuscleGroup)
                        thirdList = exercisePlans[i]!;
                    }
                  });
                },
                items: secondList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: titleStyle("Select Exercise Plan", questionSize * 0.7)),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedBodyPart,
                onChanged: (value) {
                  setState(() {
                    selectedPlan = value!;
                    oneDayWorkoutExercise[index]["Exercise Plan"] = selectedPlan;
                  });
                },
                items: thirdList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleStyle("Add or delete exercise group:", titleSize*0.3),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: index == oneDayWorkoutExercise.length - 1 &&
                  oneDayWorkoutExercise[index]["Body Part"] != null && oneDayWorkoutExercise[index]["Body Part"] != "None selected" &&
                  oneDayWorkoutExercise[index]["Muscle Group"] != null && oneDayWorkoutExercise[index]["Muscle Group"] != "Select" &&
                  oneDayWorkoutExercise[index]["Exercise Plan"] != null   && oneDayWorkoutExercise[index]["Exercise Plan"] != "Select"
                  ? () => _addNewWorkoutLine()
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                if (oneDayWorkoutExercise.length > 1) {
                  _deleteWorkoutLine(index);
                }
              },
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ],
    );
  }

  Widget parentChildDropdown({
    required int index,
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
        const SizedBox(height: 16),
      ],
    );
  }

  Column oneDayWorkout () {
    String selectedBodyPart = muscleGroups.keys.first;
    String selectedMuscleGroup = muscleGroups[selectedBodyPart]![0];
    String selectedPlan = exercisePlans.keys.first;

    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          decoration: addPageInputStyle("Name"),
          cursorColor: inputDecorationColor,
          maxLength: 50,
          validator: (value) {
            if (value == null || value.isEmpty) {
              showSnackBar( context, 'Please enter the name of the workout.');
            }
            return null;
          },
          onSaved: (value) {
            _nameMuscleGroup = value ?? '';
          },
        ),
        const SizedBox(height: 32),
        titleStyle("Add groups of exercises", questionSize*0.9),
        const SizedBox(height: 16),
        for (int i = 0; i < oneDayWorkoutExercise.length; i++)
          buildGroupOfExerciseLine(i, selectedBodyPart, selectedMuscleGroup, selectedPlan),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: _addOneDayWorkout,
          child: const Text('Save workout'),
        ),
      ],
    );
  }


  /** End One Day Workout functions **/

  /** One Week Workout functions **/

  Column oneWeekWorkout () {
    //final String _upperBodySubcategory  = "Choose";
    final String _lowerBodySubcategory  = "Choose:";
    // TODO: add from database the list and the implicit value is Pause
    workoutChoose = _lowerBodySubcategory;
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

  /** End One Week Workout functions **/

}
