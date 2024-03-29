import 'package:daily_gym_planner/routes/models/AppBar.dart';
import 'package:daily_gym_planner/routes/user/news/NewsList.dart';
import 'package:daily_gym_planner/routes/models/RiverMenu.dart';
import 'package:daily_gym_planner/routes/trainer/news/AddNews.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../util/constants.dart';

class TrainerHome extends StatefulWidget{
  const TrainerHome({super.key});

  @override
  State<TrainerHome> createState() => _TrainerHomeState();
}

class _TrainerHomeState extends State<TrainerHome>{
  String userName = "userName";
  String userRole = "trainer";

  @override
  void initState() {
    super.initState();
    _getUserDetails();
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
          selectedSection: "Home",
        ),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                MyAppBar(userRole: userRole),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50, // set the height of the fixed box as required
                    child: Container(
                      color: lightLila,
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Want to share something new? ",
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
                                        builder: (context) => const AddNewsPage(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: NewsList(userRole: userRole),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
