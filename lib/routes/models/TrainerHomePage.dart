import 'package:daily_gym_planner/routes/models/AppBar.dart';
import 'package:flutter/material.dart';



class TrainerHome extends StatefulWidget{
  TrainerHomePage createState() => TrainerHomePage();
}

class TrainerHomePage extends State<TrainerHome>{


  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        MyAppBar(),
        // other sliver widgets
      ],
    );
  }
}