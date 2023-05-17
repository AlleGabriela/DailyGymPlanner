import 'package:daily_gym_planner/routes/log_in.dart';
import 'package:daily_gym_planner/routes/trainer/news/TrainerHomePage.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../util/components_theme/box.dart';
import '../util/constants.dart';
import '../util/showSnackBar.dart';

String userIdErrorText = "User id can not be empty";
String userIdHintText = "Enter User Id";
Color userIdHintTextColor = Colors.black;
String valueChoose = "None";
List listItem = [
  "None", "Trainer", "Customer"
];

class SignUp extends StatefulWidget{
  HomeSignUp createState() => HomeSignUp();
}

class HomeSignUp extends State<SignUp> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  FirebaseAuthMethods _authService = FirebaseAuthMethods();

  Future<void> _handleSignUp() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    await _authService.handleSignUp(
      role: valueChoose,
      name: name,
      email: email,
      password: password,
      confirmpassword: confirmPassword,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Stack(
                            children: [
                              Image(image: AssetImage(barbellImage)),
                              Positioned.fill(
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 120, 0, 0),
                                      child: Text("DailyGymPlanner",
                                        style: TextStyle(color: secondColor,
                                            fontSize: titleSizePhoto,
                                            fontFamily: font1),
                                      )
                                  )
                              )
                            ]
                        )
                    ),
                    SafeArea(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          margin: const EdgeInsets.fromLTRB(
                              marginSize, marginSize, marginSize, marginSize),
                          child: Column(
                            children: [
                              Text(
                                'Sign Up into your account',
                                style: TextStyle(color: secondColor,
                                    fontSize: pageSizeName,
                                    fontFamily: font1),
                              ),
                              SizedBox(height: boxDataSize),
                              Form(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: TextField(
                                          controller: nameController,
                                          decoration: Box().textInputDecoration(
                                              'Name', 'Enter your name'),
                                        ),
                                        decoration: Box()
                                            .inputBoxDecorationShaddow(),
                                      ),
                                      SizedBox(height: boxDataSize),
                                      Container(
                                        child: TextField(
                                          controller: emailController,
                                          decoration: Box().textInputDecoration(
                                              'E-mail', 'Enter your e-mail'),
                                        ),
                                        decoration: Box()
                                            .inputBoxDecorationShaddow(),
                                      ),
                                      SizedBox(height: boxDataSize),
                                      Container(
                                        child: TextField(
                                          controller: passwordController,
                                          obscureText: true,
                                          decoration: Box().textInputDecoration(
                                              'Pasword', 'Enter your password'),
                                        ),
                                        decoration: Box()
                                            .inputBoxDecorationShaddow(),
                                      ),
                                      SizedBox(height: boxDataSize),
                                      Container(
                                        child: TextField(
                                          controller: confirmPasswordController,
                                          obscureText: true,
                                          decoration: Box().textInputDecoration(
                                              'Repeat Password',
                                              'Repeat your password'),
                                        ),
                                        decoration: Box()
                                            .inputBoxDecorationShaddow(),
                                      ),
                                      SizedBox(height: boxDataSize),
                                      Container(
                                        child: DropdownButtonFormField(
                                          style: TextStyle(color: secondColor, fontFamily: font1),
                                          dropdownColor: dropdownFieldColor,
                                          value: valueChoose,
                                          items: listItem.map(
                                                  (e) =>
                                                  DropdownMenuItem(
                                                    child: Text(e),
                                                    value: e,
                                                  )
                                          ).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              valueChoose = val as String;
                                            });
                                          },
                                          decoration: InputDecoration(),
                                        ),
                                      )
                                    ],
                                  )
                              )
                            ],
                          ),
                        )
                    ),
                    Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.fromLTRB(
                            0, 0, marginSize, marginSize),
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await _handleSignUp();
                              if( valueChoose == "Trainer") {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => TrainerHome()));
                              } else {
                                //TODO:  GO TO CUTOMER PAGE
                              }
                            } catch (e) {
                              showSnackBar(context, 'Failed to create user: $e');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              fixedSize: Size(buttonWidth, buttonHeight),
                              textStyle: TextStyle(
                                  fontSize: buttonText,
                                  fontWeight: FontWeight.bold
                              ),
                              side: BorderSide(
                                  color: buttonTextColor, width: 2),
                              backgroundColor: primaryColor,
                              foregroundColor: buttonTextColor,
                              elevation: 15
                          ),
                          child: Text("Sign Up"),
                        )
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.fromLTRB(
                          0, 0, marginSize, marginSize),
                      child: Text.rich(
                          TextSpan(
                              children: [
                                TextSpan(
                                  text: "\nAlready have an account? ",
                                  style: TextStyle(color: questionTextColor,
                                      fontSize: questionSize,
                                      fontFamily: font2),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => LogIn()));
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