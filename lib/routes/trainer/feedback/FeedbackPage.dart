import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/routes/models/AppBar.dart';
import 'package:daily_gym_planner/routes/models/ListItems.dart';
import 'package:daily_gym_planner/routes/models/RiverMenu.dart';
import 'package:daily_gym_planner/routes/trainer/feedback/ClientFeedback.dart';
import 'package:daily_gym_planner/services/ClientServices.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../util/constants.dart';

class FeedbackList extends StatefulWidget{
  const FeedbackList({super.key});

  @override
  FeedbackListPage createState() => FeedbackListPage();
}

class FeedbackListPage extends State<FeedbackList>{

  String userName = "userName";
  String trainerID = "";
  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> clients;
  String userRole = "trainer";

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    clients = getFeedbackClients();
  }

  Future<void> _getUserDetails() async {
    FirebaseAuthMethods authService = FirebaseAuthMethods();
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    if (email != null) {
      String name = await authService.getName(email) ;
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
          userRole: userRole,
          userName: userName,
          selectedSection: "Feedback",
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            MyAppBar(userRole: userRole),
            SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: FutureBuilder <List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                        future: clients,
                        builder: (context, snapshot) {
                          List clientsList = [];
                          var snapData = snapshot.data;
                          if (snapData != null) {
                            clientsList = snapData;
                          }
                          return clientsList.isNotEmpty
                              ? ListView.builder(
                            itemCount: clientsList.length,
                            itemBuilder: (BuildContext ctx , int index) {
                              final clientEmail = clientsList[index]['email'];
                              final clientID = clientsList[index].id;

                              if( clientEmail == '' ) {
                                throw Exception("The clients cannot pe accessed!");
                              }
                              return Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  child: const Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 16.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                onDismissed: (direction) async {
                                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                                  firestore.collection('customers')
                                      .doc(clientID)
                                      .update({'trainer' : '', 'workoutPlan': '', 'mealPlan': ''})
                                      .then((_) => setState(() { clients = getFeedbackClients(); }))
                                      .catchError((error) => Exception('Error deleting client from trainer:: $error'));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10), // Add space (adjust the bottom margin as needed)
                                  child: SizedBox(
                                    height: 80,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ClientFeedbackPage(
                                                  clientEmail: clientEmail,
                                                  clientID: clientID
                                              )
                                          ),
                                        );
                                      },
                                      child: listItemsWithoutImage(clientEmail, Icons.person, primaryColor),
                                    ),
                                  ),
                                ),

                              );
                            },
                          )
                              : const Center(
                            child: Text( "Clients have not given a feedback.",
                              style: TextStyle(fontSize: 20, color: Colors.black87, fontFamily: font1),
                            ),
                          );
                        },
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}