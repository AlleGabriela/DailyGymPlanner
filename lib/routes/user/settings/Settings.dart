import 'dart:io';

import 'package:daily_gym_planner/routes/customer/CustomerHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/auth_methods.dart';
import '../../../util/constants.dart';
import '../../../util/showSnackBar.dart';
import '../../models/AppBar.dart';
import '../../models/RiverMenu.dart';
import '../../trainer/news/TrainerHomePage.dart';

class Settings extends StatefulWidget{
  final String userRole;

  const Settings({super.key, required this.userRole});

  @override
  SettingsPage createState() => SettingsPage();
}

class SettingsPage extends State<Settings>{
  String userName = "";
  String userEmail = "";
  String userPassword = "";
  String userPhoto = "";
  String userLocation = "";
  bool showPassword = true;
  File? _imageFile;

  late Future<Map<String, String>> fetchDetails;

  FirebaseAuthMethods authMethods = FirebaseAuthMethods();

  @override
  void initState() {
    super.initState();
    fetchDetails = _getUserDetails();
  }

  Future<Map<String, String>> _getUserDetails() async {
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
      return {
        'userName': name,
        'userEmail': email,
        'userLocation': location,
        'userPhoto': photo,
      };
    }
    return {};
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
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
      final storageReference = FirebaseStorage.instance.ref().child('$userID/profile').child("post_$postID");
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
    if( _imageFile != null) {
      await _uploadImage();
    }
      try {
        if( _imageFile != null ) {
          if( widget.userRole == "trainer") {
            await authMethods.updatePhotoURL("trainers", userID, userPhoto);
          } else {
            await authMethods.updatePhotoURL("customers", userID, userPhoto);
          }
        }

      if( userPassword != "") {
        user?.updatePassword(userPassword);
      }

      if( widget.userRole == "trainer" ) {
        if( userName != '') {
          await authMethods.updateUsername("trainers", userID, userName);
        }
        if( userLocation != '') {
          await authMethods.updateLocation("trainers", userID, userLocation);
        } else {
          await authMethods.updateLocation("trainers", userID, "  -  ");
        }
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => TrainerHome(),
          ),
        );
      } else {
        if( userName != '') {
          await authMethods.updateUsername("customers", userID, userName);
        }
        if( userLocation != '') {
          await authMethods.updateLocation("customers", userID, userLocation);
        } else {
          await authMethods.updateLocation("customers", userID, "  -  ");
        }
        Navigator.pop(context);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const CustomerHome(),
          ),
        );
      }
      } catch (e) {
        throw Exception('Error adding news to db: $e');
      }
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: RiverMenu(
          userRole: widget.userRole,
          userName: userName,
          selectedSection: "Settings",
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            MyAppBar(userRole: widget.userRole),
            SliverFillRemaining(
              child: FutureBuilder<Map<String, String>>(
                future: fetchDetails,
                builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      valueColor:AlwaysStoppedAnimation<Color>(primaryColor),
                    ); // Display a loading indicator
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                      return buildProfile();
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
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
      userPhoto = 'photo';
    }

    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 25, right: 16),
      child: ListView(
        children: [
          const Text("Edit Profile", style: TextStyle(color: buttonTextColor, fontFamily: font1, fontSize: 20),),
          Center(
            child: Stack(
              children: [
                InkWell(
                  onLongPress: () {  _pickImage(); },
                  child: userPhoto == ""
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
                                    offset: const Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: const DecorationImage(
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
                                    offset: const Offset(0, 10))
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
          TextFormField(
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
                  userName = value ?? '';
              });
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
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
          TextFormField(
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
                icon: const Icon(
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
              },
          ),
          const SizedBox(height: 15),
          TextFormField(
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
                userLocation = value ?? '';
              });
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
}