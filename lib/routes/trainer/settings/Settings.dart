import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
  String userRole = "trainer";
  String userEmail = "";
  String userPassword = "";
  String userPhoto = "";
  String userLocation = "";
  bool showPassword = true;
  File? _imageFile;

  FirebaseAuthMethods authMethods = FirebaseAuthMethods();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _userlocationController = TextEditingController();
  TextEditingController _userpasswordController = TextEditingController();


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
    User? user = FirebaseAuth.instance.currentUser;
    String userID = await authMethods.getUserId();
    if( _imageFile != null)
        await _uploadImage();
      try {
        if( _imageFile != null )
          await authMethods.updatePhotoURL("trainers", userID, userPhoto);

        if( userPassword != "")
          user?.updatePassword(userPassword);

        await authMethods.updateUsername("trainers", userID, userName);
        await authMethods.updateLocation("trainers", userID, userLocation);
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
          userRole: userRole,
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
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: primaryColor),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              labelText: 'Name',
              hintText: userName,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: const TextStyle( fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            onChanged: (value) {
              setState(() {
                userName = value;
              });
              _updateUsername();
            },
          ),
          const SizedBox(height: 15),
          TextField(
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: primaryColor),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              labelText: 'E-mail',
              hintText: userEmail,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: const TextStyle( fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
              enabled: false
            ),
          ),
          const SizedBox(height: 15),
          TextField(
              controller: _userpasswordController,
              obscureText: showPassword,
              decoration: InputDecoration(
              labelStyle: const TextStyle(color: primaryColor),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey,
                ),
              ),
              labelText: 'Enter new password',
              hintText: userPassword,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: const TextStyle( fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
              onChanged: (value) {
                setState(() {
                  userPassword = value;
                });
                _updatePassword();
              },
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _userlocationController,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: primaryColor),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              labelText: 'Location',
              hintText: userLocation,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: const TextStyle( fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            onChanged: (value) {
              setState(() {
                userLocation = value;
              });
              _updateUserlocation();
            },
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: mealButtonColor
                ),
                onPressed: () {
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

  void _updateUsername() {
    // Perform the update logic here
    String newUsername = _usernameController.text;
    // Update the username in Firestore or perform other operations
    setState(() {
      userName = newUsername; // Update the placeholder value
    });
  }

  void _updateUserlocation() {
    // Perform the update logic here
    String newUserlocation = _userlocationController.text;
    // Update the username in Firestore or perform other operations
    setState(() {
      userLocation = newUserlocation; // Update the placeholder value
    });
  }

  void _updatePassword() async {
    String newUserpassword = _userpasswordController.text;
    // Update the username in Firestore or perform other operations
    setState(() {
      userPassword = newUserpassword; // Update the placeholder value
    });

  }
}