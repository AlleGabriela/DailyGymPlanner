import 'package:daily_gym_planner/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:daily_gym_planner/routes/sign_up.dart';
import 'package:daily_gym_planner/routes/log_in.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Text("Daily",
                          style: TextStyle(color: secondColor, fontSize: titleSize, fontFamily: font1))
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0,0,50,0),
                      child: Text("Gym",
                          style: TextStyle(color: secondColor, fontSize: titleSize, fontFamily: font1))
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0,0,marginSize,0),
                      child: Text("Planner",
                          style: TextStyle(color: secondColor, fontSize: titleSize, fontFamily: font1))
                  ),
                )
              ],
            ),
            Image(image: AssetImage(welcomeImage)),
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
                            MaterialPageRoute(builder: (context) => LogIn()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            fixedSize: Size(buttonWidth, buttonHeight),
                            textStyle: TextStyle(
                                fontSize: buttonText,
                                fontWeight: FontWeight.bold
                            ),
                            side: BorderSide(color: buttonTextColor, width: 2),
                            backgroundColor: secondColor,
                            foregroundColor: buttonTextColor,
                            elevation: 15
                        ),
                        child: Text("Log in"),
                      )
                  ),
                  Container(
                      child: ElevatedButton(
                        onPressed: () {
                            Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => SignUp()),
                            );
                        },
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            fixedSize: Size(buttonWidth, buttonHeight),
                            textStyle: TextStyle(
                                fontSize: buttonText,
                                fontWeight: FontWeight.bold
                            ),
                            side: BorderSide(color: buttonTextColor, width: 2),
                            backgroundColor: secondColor,
                            foregroundColor: buttonTextColor,
                            elevation: 15
                        ),
                        child: Text("Sign up"),
                      )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}