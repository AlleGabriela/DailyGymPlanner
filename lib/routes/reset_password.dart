import 'package:daily_gym_planner/routes/welcome_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../util/components_theme/box.dart';
import '../util/constants.dart';

class PassReset extends StatelessWidget{
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
                                'Reset your password',
                                style: TextStyle(color: secondColor, fontSize: pageSizeName, fontFamily: font1),
                              ),
                              SizedBox(height: boxDataSize),
                              Form(
                                  child: Column(
                                    children: [
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
                                          decoration: Box().textInputDecoration('New Pasword', 'Enter your new password'),
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
                        margin: const EdgeInsets.fromLTRB(0,0,marginSize, marginSize),
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
                              side: BorderSide(color: buttonTextColor, width: 2),
                              backgroundColor: primaryColor,
                              foregroundColor: buttonTextColor,
                              elevation: 15
                          ),
                          child: Text("Submit"),
                        )
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.fromLTRB(0,marginSize,marginSize, marginSize),
                      child: Text.rich(
                          TextSpan(
                              children: [
                                TextSpan(
                                  text: "\nBack To Start Page! ",
                                  style: TextStyle(color: questionTextColor, fontSize: questionSize, fontFamily: font2),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (){

                                    },
                                )
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