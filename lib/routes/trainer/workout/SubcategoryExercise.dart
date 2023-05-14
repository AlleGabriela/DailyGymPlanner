import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:flutter/material.dart';
import '../../../services/workout/WorkoutServices.dart';
import '../../../util/constants.dart';

class SubcategoryExercise extends StatefulWidget{
  final String categoryName;
  final String subcategoryName;

  const SubcategoryExercise({super.key, required this.categoryName, required this.subcategoryName});

  @override
  SubcategoryExercisePage createState() => SubcategoryExercisePage(categoryName, subcategoryName);
}

class SubcategoryExercisePage extends State<SubcategoryExercise>{
  String userName = "userName";
  String categoryName = "";
  String subcategoryName = "";

  List exercises = [];
  List<Widget> exerciseList = [];

  SubcategoryExercisePage(this.categoryName, this.subcategoryName);

  @override
  void initState() {
    super.initState();
    handleUserID();
  }

  void handleUserID() async {
    FirebaseAuthMethods authMethods = FirebaseAuthMethods();
    String userId = await authMethods.getUserId();
    getSubcategoryItems(userId);
    if( exerciseList == []) {
      throw Exception("The list is still empty!");
    }
  }

  void getSubcategoryItems(String userId) async {
    if (categoryName == "Upper Body Workouts") {
      categoryName = "Upper Body";
      exercises = await getExercisesName(categoryName, subcategoryName);
    } else {
      categoryName = "Lower Body";
      exercises = await getExercisesName(categoryName, subcategoryName);
    }

    if (exercises.isNotEmpty) {
      int index = 1;
      exerciseList = [
        for (final exercise in exercises)
          await buildExerciseContainer(exercise, index++, userId),
      ];
    }
    setState(() {});
  }

  Future<Widget> buildExerciseContainer(doc, int index, String userId ) async{
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: primaryColor,
        child: Text('$index'),
      ),
      title: Flexible(
        child: Text(
          doc,
          style: const TextStyle(color: Colors.black87, fontFamily: font1),
        ),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'delete') {
            // TODO: ADD REMOVE
          }
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text(subcategoryName),
            backgroundColor: primaryColor,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon:const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                exerciseList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}