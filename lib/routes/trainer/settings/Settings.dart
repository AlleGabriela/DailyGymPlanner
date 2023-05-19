import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/auth_methods.dart';
import '../../../util/constants.dart';
import '../../../util/showSnackBar.dart';
import '../../models/AppBar.dart';
import '../../models/RiverMenu.dart';
import '../news/TrainerHomePage.dart';

class Settings extends StatefulWidget{
  const Settings({super.key});

  @override
  SettingsPage createState() => SettingsPage();
}

class SettingsPage extends State<Settings>{
  String userName = "";
  String userEmail = "";
  String userPassword = "";
  String userPhoto = "";
  String userLocation = "";
  bool showPassword = false;
  File? _imageFile;

  FirebaseAuthMethods authMethods = FirebaseAuthMethods();

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    if (email != null) {
      String name = await authMethods.getName(email) ;
      String location = await authMethods.getLocation(email);
      String photo = await authMethods.getPhoto(email);
      setState(() {
        userName = name;
        userEmail = email;
        userLocation = location;
        userPhoto = photo;
      });
    }
    print("User photo: $userPhoto");
  }

  Future<void> _pickImage() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
    else
    {
      showSnackBar(context, 'Image not added!');
    }
  }

  Future _uploadImage() async {
    try {
      String userID = await authMethods.getUserId();
      final postID = DateTime.now().millisecondsSinceEpoch.toString();
      final storageReference = FirebaseStorage.instance.ref().child('${userID}/profile').child("post_$postID");
      await storageReference.putFile(_imageFile!);
      final downloadUrl = await storageReference.getDownloadURL();
      setState(() {
        userPhoto = downloadUrl;
      });
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  void saveChanges() async {
    String userID = await authMethods.getUserId();
    await _uploadImage();
      try {
        await authMethods.updatePhotoURL("trainers", userID, userPhoto);
        showSnackBar(context, "News added succesfully!");
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => TrainerHome(),
          ),
        );
      } catch (e) {
        throw Exception('Error adding news to Firestore: $e');
      }
    }

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
            labelStyle: const TextStyle(color: primaryColor),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
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
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  Container buildProfile(){
    ImageProvider<Object> imageShowed;
    if(_imageFile == null)
    {
      imageShowed = NetworkImage(userPhoto);
    } else {
      imageShowed = FileImage(_imageFile!);
    }

    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 25, right: 16),
      child: ListView(
        children: [
          Text("Edit Profile", style: TextStyle(color: buttonTextColor, fontFamily: font1, fontSize: 20),),
          Center(
            child: Stack(
              children: [
                InkWell(
                  onLongPress: () {  _pickImage(); },
                  child: userPhoto == null
                      ? Container(
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
                                  image: AssetImage('assets/images/user.png'))),
                        )
                      : Container(
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
                                  image: imageShowed)),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox( height: 25),
          buildTextField("Name", userName, false),
          buildTextField("E-mail", userEmail, false),
          buildTextField("Password", "********", true),
          buildTextField("Location", userLocation, false),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: mealButtonColor
                ),
                onPressed: () {
                  // TODO Add functionality
                  saveChanges();
                },
                child: const Text('Save changes'),
              ),
            ],
          )
        ],
      ),
    );
  }
}