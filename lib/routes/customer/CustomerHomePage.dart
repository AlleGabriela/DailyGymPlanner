import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_methods.dart';
import '../../util/constants.dart';
import '../models/AppBar.dart';
import '../models/RiverMenu.dart';
import '../trainer/news/NewsList.dart';

class CustomerHome extends StatefulWidget{
  CustomerHomePage createState() => CustomerHomePage();
}

class CustomerHomePage extends State<CustomerHome> {
  String userName = "userName";
  String userRole = "customer";
  String trainerID = "";
  String trainerName = "";
  String trainerEmail = "";
  String trainerLocation = "";
  String trainerPhoto = "";

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
      String name = await _authService.getName(email);
      String trainer = await _authService.getTrainer(email);
      String emailTrainer = await _authService.getTrainerDetails(trainer, "email");
      String nameTrainer = await _authService.getTrainerDetails(trainer, "name");
      String locationTrainer = await _authService.getTrainerDetails(trainer, "location");
      String photoTrainer = await _authService.getTrainerDetails(trainer, "photo");
      setState(() {
        userName = name;
        trainerID = trainer;
        trainerName = nameTrainer;
        trainerEmail = emailTrainer;
        trainerLocation = locationTrainer;
        trainerPhoto = photoTrainer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: RiverMenu(
          userRole: userRole,
          userName: userName,
          selectedSection: "Home",
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            MyAppBar(),
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(20),
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: lightLila,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(trainerPhoto),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name: $trainerName",
                            style: TextStyle(
                              color: buttonTextColor,
                              fontSize: questionSize,
                              fontFamily: font2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "E-mail: $trainerEmail",
                            style: TextStyle(
                              color: buttonTextColor,
                              fontSize: questionSize,
                              fontFamily: font2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Location: $trainerLocation",
                            style: TextStyle(
                              color: buttonTextColor,
                              fontSize: questionSize,
                              fontFamily: font2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: NewsList(userRole: userRole),
            )
          ],
        ),
      ),
    );
  }

}