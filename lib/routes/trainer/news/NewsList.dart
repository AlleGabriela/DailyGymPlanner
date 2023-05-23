import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/routes/trainer/news/NewsDetails.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';

import '../../models/ListItems.dart';

class NewsList extends StatefulWidget {
  final String userRole;

  const NewsList({super.key, required this.userRole});

  @override
  _NewsListState createState() => _NewsListState(userRole);
}

class _NewsListState extends State<NewsList> {
  String userId = '';
  String userRole = "";
  List<Widget> newsList = [];

  _NewsListState(this.userRole);

  @override
  void initState() {
    super.initState();
    handleUserID();
  }

  void handleUserID() async {
    FirebaseAuthMethods authMethods = FirebaseAuthMethods();
    if( userRole == "trainer") {
      userId = await authMethods.getUserId();
    } else {
      User? user = FirebaseAuth.instance.currentUser;
      String? email = user?.email;
      if (email != null) {
        String trainer = await authMethods.getTrainer(email);
        setState(() {
          userId = trainer;
        });
      }
    }
    handleNewsData();
    if( newsList == []) {
      throw Exception("The list is still empty!");
    }
  }

  void handleNewsData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("trainers")
        .doc(userId)
        .collection("news")
        .orderBy('createdAt', descending: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      newsList = snapshot.docs.map((doc) {
        String title = doc['title'];
        String imageUrl = doc['imageUrl'];
        String description = doc['description'];

        if( title == '' || imageUrl == '' || description == '') {
          throw Exception("The news cannot pe accessed!");
        }
        if( userRole == "trainer") {
          return Dismissible(
            key: Key(doc.id),
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
              await FirebaseFirestore.instance
                  .collection("trainers")
                  .doc(userId)
                  .collection("news")
                  .doc(doc.id)
                  .delete();
              setState(() {});
            },
            child: Container(
                margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
                height: 180,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetails(
                          title: title,
                          imageUrl: imageUrl,
                          description: description,
                        ),
                      ),
                    );
                  },
                  child: listItems(title, imageUrl, Icons.newspaper, primaryColor),
                )
            ),
          );
        } else {
          return Container(
                margin: const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
                height: 180,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetails(
                          title: title,
                          imageUrl: imageUrl,
                          description: description,
                        ),
                      ),
                    );
                  },
                  child: listItems(title, imageUrl, Icons.newspaper, primaryColor),
                )
          );
        }

      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            newsList,
          ),
        ),
      ],
    );
  }
}