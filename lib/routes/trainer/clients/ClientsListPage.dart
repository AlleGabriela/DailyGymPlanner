import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/routes/models/AppBar.dart';
import 'package:daily_gym_planner/routes/models/ListItems.dart';
import 'package:daily_gym_planner/routes/models/RiverMenu.dart';
import 'package:daily_gym_planner/routes/trainer/clients/EditClient.dart';
import 'package:daily_gym_planner/services/ClientServices.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../util/constants.dart';
import 'AddClient.dart';

class ClientsList extends StatefulWidget{
  const ClientsList({super.key});

  @override
  ClientsListPage createState() => ClientsListPage();
}

class ClientsListPage extends State<ClientsList>{

  String userName = "userName";
  String trainerID = "";
  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> clients;
  String userRole = "trainer";

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    clients = getClients();
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
          selectedSection: "Clients",
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            MyAppBar(userRole: userRole),
            SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    color: lightLila,
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Want to add a new client? ",
                              style: const TextStyle(
                                color: buttonTextColor,
                                fontSize: questionSize,
                                fontFamily: font2,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddClientPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                              final clientName = clientsList[index]['name'];
                              final clientEmail = clientsList[index]['email'];
                              final clientPhoto = clientsList[index]['photo'];
                              final clientLocation = clientsList[index]['location'];
                              final clientWorkoutPlan = clientsList[index]['workoutPlan'];
                              final clientMealPlan = clientsList[index]['mealPlan'];
                              final clientID = clientsList[index].id;

                              if( clientName == '' || clientEmail == '' ) {
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
                                      .then((_) => setState(() { clients = getClients(); }))
                                      .catchError((error) => Exception('Error deleting client from trainer:: $error'));
                                },
                                child: SizedBox(
                                  height: 220,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditClientPage(
                                              clientName: clientName,
                                              clientEmail: clientEmail,
                                              clientPhoto: clientPhoto,
                                              clientLocation: clientLocation,
                                              clientWorkoutPlan: clientWorkoutPlan,
                                              clientMealPlan: clientMealPlan,
                                              clientID: clientID
                                          )
                                        ),
                                      );
                                    },
                                    child: listClientsAndTrainer(clientPhoto, clientName, clientEmail, clientLocation),
                                  )
                                ),
                              );
                            },
                          )
                          : const Center(
                          child: Text( "No client added yet.",
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