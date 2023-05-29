import 'package:daily_gym_planner/routes/authentification/welcome_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../services/auth_methods.dart';
import '../../util/components_theme/box.dart';
import '../../util/constants.dart';
import '../../util/showSnackBar.dart';

class PassReset extends StatefulWidget{
  const PassReset({super.key});

  @override
  HomePassReset createState() => HomePassReset();
}

class HomePassReset extends State<PassReset>{
  final emailController = TextEditingController();

  final FirebaseAuthMethods _authService = FirebaseAuthMethods();

  Future<void> _handlePassReset() async {
    String email = emailController.text.trim();

    await _authService.handlePassReset(
      email: email,
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
                                'Reset your password',
                                style: TextStyle(color: secondColor, fontSize: pageSizeName, fontFamily: font1),
                              ),
                              const SizedBox(height: boxDataSize),
                              Form(
                                child: Container(
                                  decoration: Box().inputBoxDecorationShaddow(),
                                  child: TextField(
                                    controller: emailController,
                                    decoration: Box().textInputDecoration('E-mail', 'Enter your e-mail'),
                                  ),
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
                              _handlePassReset();
                            } catch (e) {
                              showSnackBar(context, 'Email does not exist: $e');
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
                          child: const Text("Reset"),
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
                                  style: const TextStyle(color: questionTextColor, fontSize: questionSize, fontFamily: font2),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
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