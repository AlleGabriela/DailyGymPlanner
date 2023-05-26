import 'package:daily_gym_planner/routes/log_in.dart';
import 'package:daily_gym_planner/routes/trainer/news/TrainerHomePage.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../util/components_theme/box.dart';
import '../util/constants.dart';
import '../util/showSnackBar.dart';
import 'customer/CustomerHomePage.dart';

class SignUp extends StatefulWidget{
  const SignUp({super.key});

  @override
  HomeSignUp createState() => HomeSignUp();
}

class HomeSignUp extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String nameController = '';
  String emailController = '';
  String passwordController = '';
  String confirmPasswordController = '';

  String valueChoose = "None";
  List listItem = [ "None", "Trainer", "Customer" ];

  void _handleSignUp() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {

      _formKey.currentState!.save();
      FirebaseAuthMethods authService = FirebaseAuthMethods();
      try {
        await authService.handleSignUp(
          role: valueChoose,
          name: nameController,
          email: emailController,
          password: passwordController,
          confirmpassword: confirmPasswordController,
          context: context,
        );
        if( valueChoose == "Trainer") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TrainerHome()));
        } else if( valueChoose == "Customer") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CustomerHome()));
        }
      } catch (e) {
        throw Exception('Error creating the user: $e');
      }
    }
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
                              const Image(image: AssetImage(barbellImage)),
                              Positioned.fill(
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 120, 0, 0),
                                      child: const Text("DailyGymPlanner",
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
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          margin: const EdgeInsets.fromLTRB(
                              marginSize, marginSize, marginSize, marginSize),
                          child: Column(
                            children: [
                              const Text(
                                'Sign Up into your account',
                                style: TextStyle(color: secondColor,
                                    fontSize: pageSizeName,
                                    fontFamily: font1),
                              ),
                              const SizedBox(height: boxDataSize),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: Box()
                                            .inputBoxDecorationShaddow(),
                                        child: TextFormField(
                                          cursorColor: inputDecorationColor,
                                          decoration: Box().textInputDecoration(
                                              'Name', 'Enter your name'),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              showSnackBar( context, 'Please complete all fields.');
                                              throw Exception('Field cannot be empty.');
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            nameController = value ?? '';
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: boxDataSize),
                                      Container(
                                        decoration: Box()
                                            .inputBoxDecorationShaddow(),
                                        child: TextFormField(
                                          cursorColor: inputDecorationColor,
                                          decoration: Box().textInputDecoration(
                                              'E-mail', 'Enter your e-mail'),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              showSnackBar( context, 'Please complete all fields.');
                                              throw Exception('Field cannot be empty.');
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            emailController = value ?? '';
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: boxDataSize),
                                      Container(
                                        decoration: Box()
                                            .inputBoxDecorationShaddow(),
                                        child: TextFormField(
                                          cursorColor: inputDecorationColor,
                                          obscureText: true,
                                          decoration: Box().textInputDecoration(
                                              'Password', 'Enter your password'),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              showSnackBar( context, 'Please complete all fields.');
                                              throw Exception('Field cannot be empty.');
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            passwordController = value ?? '';
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: boxDataSize),
                                      Container(
                                        decoration: Box()
                                            .inputBoxDecorationShaddow(),
                                        child: TextFormField(
                                          obscureText: true,
                                          decoration: Box().textInputDecoration(
                                              'Repeat Password',
                                              'Repeat your password'),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              showSnackBar( context, 'Please complete all fields.');
                                              throw Exception('Field cannot be empty.');
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            confirmPasswordController = value ?? '';
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: boxDataSize),
                                      DropdownButtonFormField(
                                        style: const TextStyle(color: secondColor, fontFamily: font1),
                                        dropdownColor: dropdownFieldColor,
                                        value: valueChoose,
                                        items: listItem.map(
                                                (e) =>
                                                DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e),
                                                )
                                        ).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            valueChoose = val as String;
                                          });
                                        },
                                        decoration: const InputDecoration(),
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
                          onPressed: _handleSignUp,
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              fixedSize: const Size(buttonWidth, buttonHeight),
                              textStyle: const TextStyle(
                                  fontSize: buttonText,
                                  fontWeight: FontWeight.bold
                              ),
                              side: const BorderSide(
                                  color: buttonTextColor, width: 2),
                              backgroundColor: primaryColor,
                              foregroundColor: buttonTextColor,
                              elevation: 15
                          ),
                          child: const Text("Sign Up"),
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
                                  style: const TextStyle(color: questionTextColor,
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