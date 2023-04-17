import 'package:daily_gym_planner/routes/models/AppBar.dart';
import 'package:daily_gym_planner/routes/models/ListOfBoxes.dart';
import 'package:daily_gym_planner/routes/models/RiverMenu.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TrainerHome extends StatefulWidget{
  TrainerHomePage createState() => TrainerHomePage();
}

class TrainerHomePage extends State<TrainerHome>{

  String userName = "userName";

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {

    FirebaseAuthMethods _authService = FirebaseAuthMethods();
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    if (email != null) {
      String name = await _authService.getName(email) ;
      setState(() {
        userName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: RiverMenu(
          userName: userName,
          selectedSection: "Home",
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            MyAppBar(),
            SliverList(
                delegate: SliverChildListDelegate(
                  ListOfBoxes.buildBoxes(),
                ),
            ), // other sliver widgets
          ],
        ),
      ),
    );
  }
}
