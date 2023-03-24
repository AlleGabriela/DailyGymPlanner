import 'package:daily_gym_planner/routes/log_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../util/components_theme/box.dart';
import '../util/constants.dart';

String userIdErrorText = "User id can not be empty";
String userIdHintText = "Enter User Id";
Color userIdHintTextColor = Colors.black;

class SignUp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
          child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: Stack(
                          children: [
                            Image(image: AssetImage(barbellImage)),
                            Positioned.fill(
                                child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.fromLTRB(0,120,0,0),
                                    child: Text("DailyGymPlanner",
                                      style: TextStyle(color: secondColor, fontSize: titleSizePhoto, fontFamily: font1),
                                    )
                                )
                            )
                          ]
                      )
                  ),
                  SafeArea(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        margin: const EdgeInsets.fromLTRB(marginSize, marginSize, marginSize, marginSize),
                        child: Column(
                          children: [
                            Text(
                              'Sign Up into your account',
                              style: TextStyle(color: secondColor, fontSize: pageSizeName, fontFamily: font1),
                            ),
                            SizedBox(height: boxDataSize),
                            Form(
                                child: Column(
                                  children: [
                                    Container(
                                      child: TextField(
                                        decoration: Box().textInputDecoration('Name', 'Enter your name'),
                                      ),
                                      decoration: Box().inputBoxDecorationShaddow(),
                                    ),
                                    SizedBox(height: boxDataSize),
                                    Container(
                                      child: TextField(
                                        decoration: Box().textInputDecoration('Phone Number', 'Enter your phone number'),
                                      ),
                                      decoration: Box().inputBoxDecorationShaddow(),
                                    ),
                                    SizedBox(height: boxDataSize),
                                    Container(
                                      child: TextField(
                                        decoration: Box().textInputDecoration('E-mail', 'Enter your e-mail'),
                                      ),
                                      decoration: Box().inputBoxDecorationShaddow(),
                                    ),
                                    SizedBox(height: boxDataSize),
                                    Container(
                                      child: TextField(
                                        obscureText: true,
                                        decoration: Box().textInputDecoration('Pasword', 'Enter your password'),
                                      ),
                                      decoration: Box().inputBoxDecorationShaddow(),
                                    ),
                                    SizedBox(height: boxDataSize),
                                    Container(
                                      child: TextField(
                                        obscureText: true,
                                        decoration: Box().textInputDecoration('Repeat Password', 'Repeat your password'),
                                      ),
                                      decoration: Box().inputBoxDecorationShaddow(),
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                      )
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: const EdgeInsets.fromLTRB(0,0,marginSize, marginSize),
                    child: Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(
                                  text: "Already have an account? ",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
                                    },
                                  style: TextStyle(color: questionTextColor, fontSize: questionSize, fontFamily: font2)
                              ),
                            ]
                        )
                    ),
                  )
                ],
              )
          )
      )
    );
  }
}