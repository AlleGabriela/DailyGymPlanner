import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/ClientServices.dart';
import '../../services/auth_methods.dart';
import '../../util/constants.dart';
import '../models/AppBar.dart';
import '../models/ListItems.dart';
import '../models/RiverMenu.dart';
import 'chatPage.dart';


class ConversationList extends StatefulWidget {
  const ConversationList({super.key});

  @override
  ConversationListPage createState() => ConversationListPage();
}

class ConversationListPage extends State<ConversationList> {
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
      String id = await authService.getUserId();
      setState(() {
        userName = name;
        trainerID = id;
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
          selectedSection: "Conversations",
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            MyAppBar(userRole: userRole),
            SliverFillRemaining(
              child: Column(
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
                              final clientName = clientsList[index]['name'];
                              final clientEmail = clientsList[index]['email'];
                              final clientPhoto = clientsList[index]['photo'];
                              final clientID = clientsList[index].id;
                              List<String> ids = [trainerID, clientID];
                              ids.sort();
                              String chatRoomId = ids.join("_");

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
                                child: SizedBox(
                                    height: 120,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatPage(receiverUserEmail: clientEmail, receiverUserID: clientID),
                                          ),
                                        );
                                      },
                                      child: chatComponent(clientPhoto, clientName, clientEmail),
                                    )
                                ),
                              );
                            },
                          )
                              : const Center(
                            child: Text( "Conversations are not disponible now.",
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

