import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/routes/trainer/Workout/WorkoutListPage.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:daily_gym_planner/services/workout/OneDayWorkoutServices.dart';
import 'package:daily_gym_planner/services/workout/OneWeekWorkoutServices.dart';
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

  String workoutChoose = "";
  List listWorkouts = [];

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

  /** One Day Workout Variables **/
  String _nameOneDayWorkout = "";
  List<Map<String, dynamic>> oneDayWorkoutExercise = [];

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
  /** End One Day Workout Variables **/

  /** One Week Workout Variables **/
  List<String> oneDayWorkoutsNames = [];
  String _nameOneWeekWorkout = "";

  String monday = "";
  String tuesday = "";
  String wednesday = "";
  String thursday = "";
  String friday = "";
  String saturday = "";
  String sunday = "";
  /** End One Week Workout Variables **/

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
    List<String> oneDayWorkoutWorkouts = [];

    if (_formKey.currentState != null &&
        _formKey.currentState!.validate())
    {
      _formKey.currentState!.save();
      String userID = await authMethods.getUserId();
      for(int i=0; i<oneDayWorkoutExercise.length; i++) {
          oneDayWorkoutWorkouts.add(await getMuscleGroupReference(oneDayWorkoutExercise[i]['Body Part'], oneDayWorkoutExercise[i]['Muscle Group'], oneDayWorkoutExercise[i]['Exercise Plan']));
      }
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

  void _addOneWeekWorkout() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate())
    {
      _formKey.currentState!.save();
      String userID = await authMethods.getUserId();
      final oneWeekPlan = OneWeekWorkoutPlan(
          userID,
          _nameOneWeekWorkout,
          monday,
          tuesday,
          wednesday,
          thursday,
          friday,
          saturday,
          sunday
      );

      try {
        await oneWeekPlan.addOneWeekWorkoutToFirestore();
        showSnackBar(context, "One week workout plan added succesfully!");
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const WorkoutList(),
          ),
        );
      } catch (e) {
        throw Exception('Error adding one week workout plan to Firestore: $e');
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
                monday = valueChoose;
                break;
              }
            case "Tuesday":
              {
                tuesday = valueChoose;
                break;
              }
            case "Wednesday":
              {
                wednesday = valueChoose;
                break;
              }
            case "Thursday":
              {
                thursday = valueChoose;
                break;
              }
            case "Friday":
              {
                friday = valueChoose;
                break;
              }
            case "Saturday":
              {
                saturday = valueChoose;
                break;
              }
            case "Sunday":
              {
                sunday = valueChoose;
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
      isExpanded: true,
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
    List<String> muscleGroupWorkoutsNames = [];
    List<String> names = await getMuscleGroupWorkoutsName(category, subcategory);
    setState(() {
      muscleGroupWorkoutsNames.clear();
      muscleGroupWorkoutsNames = names;
    });
    if (subcategory == 'Abs') {
      exercisePlans['Abs']?.clear();
      exercisePlans['Abs']?.addAll(muscleGroupWorkoutsNames);
      exercisePlans['Abs']?.sort();
    } else if (subcategory == 'Back') {
      exercisePlans['Back']?.clear();
      exercisePlans['Back']?.addAll(muscleGroupWorkoutsNames);
      exercisePlans['Back']?.sort();
    } else if (subcategory == 'Biceps') {
      exercisePlans['Biceps']?.clear();
      exercisePlans['Biceps']?.addAll(muscleGroupWorkoutsNames);
      exercisePlans['Biceps']?.sort();
    } else if (subcategory == 'Chest') {
      exercisePlans['Chest']?.clear();
      exercisePlans['Chest']?.addAll(muscleGroupWorkoutsNames);
      exercisePlans['Chest']?.sort();
    } else if (subcategory == 'Shoulders') {
      exercisePlans['Shoulders']?.clear();
      exercisePlans['Shoulders']?.addAll(muscleGroupWorkoutsNames);
      exercisePlans['Shoulders']?.sort();
    } else if (subcategory == 'Traps') {
      exercisePlans['Traps']?.clear();
      exercisePlans['Traps']?.addAll(muscleGroupWorkoutsNames);
      exercisePlans['Traps']?.sort();
    } else if (subcategory == 'Triceps') {
      exercisePlans['Triceps']?.clear();
      exercisePlans['Triceps']?.addAll(muscleGroupWorkoutsNames);
      exercisePlans['Triceps']?.sort();
    } else if (subcategory == 'Calves') {
      exercisePlans['Calves']?.clear();
      exercisePlans['Calves']?.addAll(muscleGroupWorkoutsNames);
      exercisePlans['Calves']?.sort();
    } else if (subcategory == 'Hamstrings') {
      exercisePlans['Hamstrings']?.clear();
      exercisePlans['Hamstrings']?.addAll(muscleGroupWorkoutsNames);
      exercisePlans['Hamstrings']?.sort();
    } else if (subcategory == 'Glutes') {
      exercisePlans['Glutes']?.clear();
      exercisePlans['Glutes']?.addAll(muscleGroupWorkoutsNames);
      exercisePlans['Glutes']?.sort();
    } else if (subcategory == 'Quads') {
      exercisePlans['Quads']?.clear();
      exercisePlans['Quads']?.addAll(muscleGroupWorkoutsNames);
      exercisePlans['Quads']?.sort();
    }
  }

  Widget _buildDropdownForOneDay(int index, String dropdownLabel, List<String> dropdownItems) {
    return DropdownButtonFormField<String>(
      style: TextStyle(color: Colors.grey.shade800, fontFamily: font1),
      dropdownColor: dropdownFieldColor,
      value: oneDayWorkoutExercise[index][dropdownLabel],
      items: dropdownItems
          .map((value) => DropdownMenuItem(
        child: Text(value),
        value: value,
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          oneDayWorkoutExercise[index][dropdownLabel] = value;
        });
      },
      isExpanded: true,
    );
  }

  Widget buildGroupOfExerciseLine(int index) {
    final Map<String, List<String>> muscleGroups = {
      'None selected': ['Select'],
      'Upper Body': ['Abs', 'Back', 'Biceps', 'Chest', 'Shoulders', 'Traps', 'Triceps'],
      'Lower Body': ['Calves', 'Hamstrings', 'Glutes', 'Quads'],
    };

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: titleStyle("Select Body Part", questionSize * 0.7)),
            Expanded(
               child: _buildDropdownForOneDay(index, "Body Part", muscleGroups.keys.toList()),
            ),
          ],
        ),
        if( oneDayWorkoutExercise[index]["Body Part"] != null && oneDayWorkoutExercise[index]["Body Part"] != "None selected")
          Row(
          children: [
            Expanded(child: titleStyle("Select Muscle Group", questionSize * 0.7)),
            Expanded(
              child: _buildDropdownForOneDay(index, "Muscle Group", muscleGroups[oneDayWorkoutExercise[index]["Body Part"]]!.toList() ),
            ),
          ],
        ),
        if( oneDayWorkoutExercise[index]["Muscle Group"] != null && oneDayWorkoutExercise[index]["Muscle Group"] != "Select")
          Row(
          children: [
            Expanded(child: titleStyle("Select Exercise Plan", questionSize * 0.7)),
            Expanded(
              child: _buildDropdownForOneDay(index, "Exercise Plan", exercisePlans[oneDayWorkoutExercise[index]["Muscle Group"]]!.toList()),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleStyle("Add or delete exercise group:", titleSize*0.3),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: index == oneDayWorkoutExercise.length - 1 && oneDayWorkoutExercise[index]["Exercise Plan"] != null   && oneDayWorkoutExercise[index]["Exercise Plan"] != "Select" ? _addNewWorkoutLine : null,
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

  Column oneDayWorkout () {
    String categoryName = "Upper Body";
    getMuscleGroupNames(categoryName, 'Abs');
    getMuscleGroupNames(categoryName, 'Back');
    getMuscleGroupNames(categoryName, 'Biceps');
    getMuscleGroupNames(categoryName, 'Chest');
    getMuscleGroupNames(categoryName, 'Shoulders');
    getMuscleGroupNames(categoryName, 'Traps');
    getMuscleGroupNames(categoryName, 'Triceps');

    categoryName = "Lower Body";
    getMuscleGroupNames(categoryName, 'Calves');
    getMuscleGroupNames(categoryName, 'Hamstrings');
    getMuscleGroupNames(categoryName, 'Glutes');
    getMuscleGroupNames(categoryName, 'Quads');

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
            _nameOneDayWorkout = value ?? '';
          },
        ),
        const SizedBox(height: 32),
        titleStyle("Add groups of exercises", questionSize*0.9),
        const SizedBox(height: 16),
        for (int i = 0; i < oneDayWorkoutExercise.length; i++)
          buildGroupOfExerciseLine(i),
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

  void getOneDayWorkoutsNames(String collectionName, String subcollectionName) async {
    List<String> oneDayWorkouts = [];
    List<String> names = await getOneDayWorkoutsName(collectionName, subcollectionName);
    setState(() {
      oneDayWorkouts.clear();
      oneDayWorkouts = names;
    });
    if( subcollectionName == "All One Day Workouts" ) {
      oneDayWorkoutsNames.clear();
      oneDayWorkoutsNames.add(" Rest Day");
      oneDayWorkoutsNames += oneDayWorkouts;
      oneDayWorkoutsNames.sort();
    }
  }

  Column oneWeekWorkout () {
    getOneDayWorkoutsNames("One Day Workouts", "All One Day Workouts");
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
            _nameOneWeekWorkout = value ?? '';
          },
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(child: titleStyle("Monday", questionSize * 0.8)),
            Expanded(
              child: dropdownChooseMenu(oneDayWorkoutsNames[0], oneDayWorkoutsNames, "Monday"),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: titleStyle("Tuesday", questionSize * 0.8)),
            Expanded(
              child: dropdownChooseMenu(oneDayWorkoutsNames[0], oneDayWorkoutsNames, "Tuesday"),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: titleStyle("Wednesday", questionSize * 0.8)),
            Expanded(
              child: dropdownChooseMenu(oneDayWorkoutsNames[0], oneDayWorkoutsNames, "Wednesday"),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: titleStyle("Thursday", questionSize * 0.8)),
            Expanded(
              child: dropdownChooseMenu(oneDayWorkoutsNames[0], oneDayWorkoutsNames, "Thursday"),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: titleStyle("Friday", questionSize * 0.8)),
            Expanded(
              child: dropdownChooseMenu(oneDayWorkoutsNames[0], oneDayWorkoutsNames, "Friday"),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: titleStyle("Saturday", questionSize * 0.8)),
            Expanded(
              child: dropdownChooseMenu(oneDayWorkoutsNames[0], oneDayWorkoutsNames, "Saturday"),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: titleStyle("Sunday", questionSize * 0.8)),
            Expanded(
              child: dropdownChooseMenu(oneDayWorkoutsNames[0], oneDayWorkoutsNames, "Sunday"),
            ),
          ],
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: mealButtonColor
          ),
          onPressed: _addOneWeekWorkout,
          child: const Text('Save workout plan'),
        ),
      ],
    );
  }

  /** End One Week Workout functions **/

}
