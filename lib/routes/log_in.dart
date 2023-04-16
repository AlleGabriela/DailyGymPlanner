import 'package:daily_gym_planner/routes/trainer/TrainerHomePage.dart';
import 'package:daily_gym_planner/routes/reset_password.dart';
import 'package:daily_gym_planner/routes/sign_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:daily_gym_planner/util/constants.dart';

import '../services/auth_methods.dart';
import '../util/components_theme/box.dart';
import '../util/showSnackBar.dart';

class LogIn extends StatefulWidget{
  HomeLogIn createState() => HomeLogIn();
}

  class HomeLogIn extends State<LogIn>{
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

  FirebaseAuthMethods _authService = FirebaseAuthMethods();

  Future<String> _handleLogIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    
    await _authService.handleLogIn(
      email: email,
      password: password,
      context: context,
    );
    
    return _authService.getRole(email);
  }

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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Log In into your account',
                                style: TextStyle(color: secondColor, fontSize: pageSizeName, fontFamily: font1),
                              ),
                              SizedBox(height: boxDataSize),
                              Form(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: TextField(
                                          controller: emailController,
                                          decoration: Box().textInputDecoration('E-mail', 'Enter your e-mail'),
                                        ),
                                        decoration: Box().inputBoxDecorationShaddow(),
                                      ),
                                      SizedBox(height: boxDataSize),
                                      Container(
                                        child: TextField(
                                          controller: passwordController,
                                          obscureText: true,
                                          decoration: Box().textInputDecoration('Pasword', 'Enter your password'),
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
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              String role = await _handleLogIn();
                              if( role == 'Trainer') {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => TrainerHome()));
                              } else {
                                //TODO:  GO TO CUTOMER PAGE
                              }
                            } catch (e) {
                              showSnackBar(context, 'User does not exist: $e');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              fixedSize: Size(buttonWidth, buttonHeight),
                              textStyle: TextStyle(
                                  fontSize: buttonText,
                                  fontWeight: FontWeight.bold
                              ),
                              side: BorderSide(color: buttonTextColor, width: 2),
                              backgroundColor: primaryColor,
                              foregroundColor: buttonTextColor,
                              elevation: 15
                          ),
                          child: Text("Log In"),
                        )
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.fromLTRB(0,marginSize,marginSize, marginSize),
                      child: Text.rich(
                          TextSpan(
                              children: [
                                TextSpan(
                                  text: "\nForgot Password? ",
                                  style: TextStyle(color: questionTextColor, fontSize: questionSize, fontFamily: font2),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PassReset()));
                                    },
                                ),
                                TextSpan(
                                  text: "\nDon't have an account? ",
                                  style: TextStyle(color: questionTextColor, fontSize: questionSize, fontFamily: font2),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                                    },
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