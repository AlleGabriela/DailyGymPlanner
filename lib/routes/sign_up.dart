import 'package:daily_gym_planner/routes/log_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../util/components_theme/box.dart';
import '../util/constants.dart';

String userIdErrorText = "User id can not be empty";
String userIdHintText = "Enter User Id";
Color userIdHintTextColor = Colors.black;
String valueChoose = "Trainer";
List listItem = [
  "Trainer", "Customer"
];

class SignUp extends StatefulWidget{
  HomeSignUp createState() => HomeSignUp();
}

class HomeSignUp extends State<SignUp> {
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
                                          decoration: Box().textInputDecoration(
                                              'Name', 'Enter your name'),
                                        ),
                                        decoration: Box()
                                            .inputBoxDecorationShaddow(),
                                      ),
                                      SizedBox(height: boxDataSize),
                                      Container(
                                        child: TextField(
                                          decoration: Box().textInputDecoration(
                                              'Phone Number',
                                              'Enter your phone number'),
                                        ),
                                        decoration: Box()
                                            .inputBoxDecorationShaddow(),
                                      ),
                                      SizedBox(height: boxDataSize),
                                      Container(
                                        child: TextField(
                                          decoration: Box().textInputDecoration(
                                              'E-mail', 'Enter your e-mail'),
                                        ),
                                        decoration: Box()
                                            .inputBoxDecorationShaddow(),
                                      ),
                                      SizedBox(height: boxDataSize),
                                      Container(
                                        child: TextField(
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
                                                    child: Text(e), value: e,)
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
                          onPressed: () {
                            //TODO: add redirection to ADMIN/CUSTOMER PAGE
                            //TODO HINT: look in sign_up page, there is a model
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