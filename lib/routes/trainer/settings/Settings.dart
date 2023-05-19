import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/auth_methods.dart';
import '../../../util/constants.dart';
import '../../../util/showSnackBar.dart';
import '../../models/AppBar.dart';
import '../../models/RiverMenu.dart';

class Settings extends StatefulWidget{
  const Settings({super.key});

  @override
  SettingsPage createState() => SettingsPage();
}

class SettingsPage extends State<Settings>{
  String userName = "userName";
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: RiverMenu(
          userName: userName,
          selectedSection: "Settings",
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            const MyAppBar(),
            SliverFillRemaining(
                child: buildProfile(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  Container buildProfile(){
    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 25, right: 16),
      child: ListView(
        children: [
          Text("Edit Profile", style: TextStyle(color: buttonTextColor, fontFamily: font1, fontSize: 20),),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 10))
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                          ))),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        color: primaryColor,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: accentColor,
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox( height: 25),
          buildTextField("Name", "Alexandra", false),
          buildTextField("E-mail", "ale@gmail.com", false),
          buildTextField("Password", "********", true),
          buildTextField("Location", "Timisoara, Romania", false),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: mealButtonColor
                ),
                onPressed: () {
                  // TODO Add functionality
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: mealButtonColor
                ),
                onPressed: () {
                  // TODO Add functionality
                },
                child: const Text('Save'),
              ),
            ],
          )
        ],
      ),
    );
  }
}