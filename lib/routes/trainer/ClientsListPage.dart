import 'package:daily_gym_planner/routes/models/AppBar.dart';
import 'package:daily_gym_planner/routes/models/NewsList.dart';
import 'package:daily_gym_planner/routes/models/RiverMenu.dart';
import 'package:daily_gym_planner/routes/trainer/AddNews.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../util/constants.dart';

class ClientsList extends StatefulWidget{
  ClientsListPage createState() => ClientsListPage();
}

class ClientsListPage extends State<ClientsList>{

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
          selectedSection: "Clients",
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            MyAppBar(),
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
                            //text: "\nWant to share something new? ",
                            style: TextStyle(
                              color: buttonTextColor,
                              fontSize: questionSize,
                              fontFamily: font2,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => AddNewsPage(),
                                //   ),
                                // );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // SliverFillRemaining(
            //   child: NewsList(),
            // )
          ],
        ),
      ),
    );
  }
}
