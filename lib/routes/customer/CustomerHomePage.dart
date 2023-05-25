import 'package:daily_gym_planner/routes/models/ListItems.dart';
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

  late Future<Map<String, String>> fetchDetails;

  @override
  void initState() {
    super.initState();
    fetchDetails = _getUserDetails();
  }

  Future<Map<String, String>> _getUserDetails() async {
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
      });
      return {
        'userName': name,
        'trainerID': trainer,
        'trainerName': nameTrainer,
        'trainerEmail': emailTrainer,
        'trainerLocation': locationTrainer,
        'trainerPhoto': photoTrainer,
      };
    }
    return {}; // Return an empty map if no user details are available
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
            MyAppBar(userRole: userRole),
            SliverToBoxAdapter(
              child: FutureBuilder<Map<String, String>>(
                future: fetchDetails,
                builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
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
                      child: CircularProgressIndicator(), // Display a loading indicator
                    );
                  } else if (snapshot.hasError) {
                    return Container(
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
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(
                          color: buttonTextColor,
                          fontSize: questionSize,
                          fontFamily: font2,
                        ),
                      ), // Display an error message
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final trainerName = data['trainerName'];
                    final trainerEmail = data['trainerEmail'];
                    final trainerLocation = data['trainerLocation'];
                    final trainerPhoto = data['trainerPhoto'];

                    return listClientsAndTrainer(trainerPhoto!, trainerName!, trainerEmail!, trainerLocation!);
                  } else {
                    return Container(
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
                      child: Text(
                        'No data available',
                        style: TextStyle(
                          color: buttonTextColor,
                          fontSize: questionSize,
                          fontFamily: font2,
                        ),
                      ), // Handle case when no data is available
                    );
                  }
                },
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
