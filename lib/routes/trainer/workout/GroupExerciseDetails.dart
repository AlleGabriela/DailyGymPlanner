import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:flutter/material.dart';
import '../../../services/workout/MuscleGroupExerciseServices.dart';
import '../../../util/constants.dart';

class GroupExerciseDetails extends StatefulWidget{
  final String categoryName;
  final String subcategoryName;
  final String title;

  const GroupExerciseDetails({super.key, required this.categoryName, required this.subcategoryName, required this.title});

  @override
  GroupExerciseDetailsPage createState() => GroupExerciseDetailsPage();
}

class GroupExerciseDetailsPage extends State<GroupExerciseDetails>{
  String userName = "userName";

  List exercises = [];
  List<Widget> exerciseList = [];

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
    exercises = await getExerciseFromOneMuscleGroup(widget.title, userId, widget.categoryName, widget.subcategoryName);
    if (exercises.isNotEmpty) {
      int index = 1;
      exerciseList = [for (final exercise in exercises) await buildGroupOfExerciseList(exercise, index++)];
    }
    setState(() {});
  }

  Future<Container> buildGroupOfExerciseList(doc, int index) async{
    String name = doc['name'];
    String nrSeries = doc['nrSeries'];
    String nrReps = doc['nrReps'];

    return Container(
      margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
      decoration: BoxDecoration(
        border: Border.all(
            color: lightLila,
            width: 1.0,
          ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor,
          child: Text('$index'),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                name,
                style: const TextStyle(color: Colors.black, fontFamily: font1),
              ),
            ),
          ],
        ),
        subtitle: Text(
          ' Nr series: $nrSeries \n Nr reps: $nrReps',
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
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