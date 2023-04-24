import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/routes/models/ListItems.dart';
import 'package:daily_gym_planner/routes/models/NewsDetails.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  String userId = '';
  List<Widget> newsList = [];

  @override
  void initState() {
    super.initState();
    handleUserID();
  }

  void handleUserID() async {
    FirebaseAuthMethods authMethods = FirebaseAuthMethods();
    userId = await authMethods.getUserId();
    handleNewsData();
    if( newsList == [])
      throw Exception("The list is still empty!");
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

        if( title == '' || imageUrl == '' || description == '')
          throw Exception("The news cannot pe accessed!");

        return Container(
          margin: EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
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




