import 'package:cloud_firestore/cloud_firestore.dart';
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

        return Dismissible(
          key: Key(doc.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
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
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: dropdownFieldColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ],
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: SizedBox(
              height: 300,
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
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.3,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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




