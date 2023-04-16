import 'package:daily_gym_planner/routes/models/AppBar.dart';
import 'package:daily_gym_planner/routes/models/RiverMenu.dart';
import 'package:flutter/material.dart';

class TrainerHome extends StatefulWidget{
  TrainerHomePage createState() => TrainerHomePage();
}

class TrainerHomePage extends State<TrainerHome>{

  void onLogout() {
    // TODO: Implement logout functionality.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: RiverMenu(
            userName: "userName",
            onLogout: onLogout,
        ),
      body: CustomScrollView(
        slivers: <Widget>[
          MyAppBar(),
          // other sliver widgets
        ],
      ),
    ),
    );
  }
}