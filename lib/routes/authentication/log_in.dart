import 'package:daily_gym_planner/routes/trainer/news/TrainerHomePage.dart';
import 'package:daily_gym_planner/routes/authentication/reset_password.dart';
import 'package:daily_gym_planner/routes/authentication/sign_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:daily_gym_planner/util/constants.dart';

import '../../services/auth_methods.dart';
import '../../util/components_theme/box.dart';
import '../../util/showSnackBar.dart';
import '../customer/CustomerHomePage.dart';

class LogIn extends StatefulWidget{
  const LogIn({super.key});

  @override
  HomeLogIn createState() => HomeLogIn();
}

  class HomeLogIn extends State<LogIn>{
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

  final FirebaseAuthMethods _authService = FirebaseAuthMethods();

  Future<String> _handleLogIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    
    await _authService.handleLogIn(
      email: email,
      password: password,
      context: context,
    );
    return await _authService.getRole(email);
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
                              const Image(image: AssetImage(barbellImage)),
                              Positioned.fill(
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.fromLTRB(0,120,0,0),
                                      child: const Text("DailyGymPlanner",
                                        style: TextStyle(color: secondColor, fontSize: titleSizePhoto, fontFamily: font1),
                                      )
                                  )
                              )
                            ]
                        )
                    ),
                    SafeArea(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          margin: const EdgeInsets.fromLTRB(marginSize, marginSize, marginSize, marginSize),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Log In into your account',
                                style: TextStyle(color: secondColor, fontSize: pageSizeName, fontFamily: font1),
                              ),
                              const SizedBox(height: boxDataSize),
                              Form(
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: Box().inputBoxDecorationShaddow(),
                                        child: TextField(
                                          key: const Key("emailField"),
                                          controller: emailController,
                                          decoration: Box().textInputDecoration('E-mail', 'Enter your e-mail'),
                                        ),
                                      ),
                                      const SizedBox(height: boxDataSize),
                                      Container(
                                        decoration: Box().inputBoxDecorationShaddow(),
                                        child: TextField(
                                          key: const Key("passwordField"),
                                          controller: passwordController,
                                          obscureText: true,
                                          decoration: Box().textInputDecoration('Password', 'Enter your password'),
                                        ),
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
                          key: const Key("logInButton"),
                          onPressed: () async {
                            try {
                              String role = await _handleLogIn();
                              if( role == 'Trainer') {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => TrainerHome()));
                              } else {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const CustomerHome()));
                              }
                            } catch (e) {
                              showSnackBar(context, 'User does not exist: $e');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              fixedSize: const Size(buttonWidth, buttonHeight),
                              textStyle: const TextStyle(
                                  fontSize: buttonText,
                                  fontWeight: FontWeight.bold
                              ),
                              side: const BorderSide(color: buttonTextColor, width: 2),
                              backgroundColor: primaryColor,
                              foregroundColor: buttonTextColor,
                              elevation: 15
                          ),
                          child: const Text("Log In"),
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
                                  style: const TextStyle(color: questionTextColor, fontSize: questionSize, fontFamily: font2),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PassReset()));
                                    },
                                ),
                                TextSpan(
                                  text: "\nDon't have an account? ",
                                  style: const TextStyle(color: questionTextColor, fontSize: questionSize, fontFamily: font2),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
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