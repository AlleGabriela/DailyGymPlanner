import 'dart:async';

import 'package:daily_gym_planner/routes/customer/CustomerHomePage.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daily_gym_planner/routes/authentication/sign_up.dart';
import 'package:daily_gym_planner/routes/authentication/log_in.dart';

import '../trainer/news/TrainerHomePage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  String role = 'None';

  void getUserRole () async {
    FirebaseAuthMethods authUser = FirebaseAuthMethods();
    role = await authUser.getRole(FirebaseAuth.instance.currentUser!.email!);
  }

  @override
  void initState() {
    super.initState();

    int duration = 0;
    if (FirebaseAuth.instance.currentUser != null) {
      getUserRole();
      duration = 2;
    }

    Timer(
      Duration(seconds: duration),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => role != 'None'
                ? role == 'Trainer'
                  ? TrainerHome()
                  : const CustomerHome()
                : Scaffold(
                  body: Container(
                    alignment: Alignment.center,
                      color: primaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    margin: const EdgeInsets.fromLTRB(marginSize,marginSize,0,0),
                                    child: const Text("Daily",
                                        style: TextStyle(color: secondColor, fontSize: titleSize, fontFamily: font1))
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                    margin: const EdgeInsets.fromLTRB(0,0,50,0),
                                    child: const Text("Gym",
                                        style: TextStyle(color: secondColor, fontSize: titleSize, fontFamily: font1))
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    margin: const EdgeInsets.fromLTRB(0,0,marginSize,0),
                                    child: const Text("Planner",
                                        style: TextStyle(color: secondColor, fontSize: titleSize, fontFamily: font1))
                                ),
                              )
                            ],
                          ),
                          const Image(image: AssetImage(welcomeImage)),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.fromLTRB(0,0,marginSize,0),
                            child: Column(
                              children: [
                                Container(
                                    margin: const EdgeInsets.fromLTRB(0,0,0,10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => const LogIn()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: const StadiumBorder(),
                                          fixedSize: const Size(buttonWidth, buttonHeight),
                                          textStyle: const TextStyle(
                                              fontSize: buttonText,
                                              fontWeight: FontWeight.bold
                                          ),
                                          side: const BorderSide(color: buttonTextColor, width: 2),
                                          backgroundColor: secondColor,
                                          foregroundColor: buttonTextColor,
                                          elevation: 15
                                      ),
                                      child: const Text("Log in"),
                                    )
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => const SignUp()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      fixedSize: const Size(buttonWidth, buttonHeight),
                                      textStyle: const TextStyle(
                                          fontSize: buttonText,
                                          fontWeight: FontWeight.bold
                                      ),
                                      side: const BorderSide(color: buttonTextColor, width: 2),
                                      backgroundColor: secondColor,
                                      foregroundColor: buttonTextColor,
                                      elevation: 15
                                  ),
                                  child: const Text("Sign up"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor:AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          )),
    );
  }
}