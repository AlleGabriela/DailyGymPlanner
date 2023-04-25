import 'dart:io';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:daily_gym_planner/util/showSnackBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/NewsServices.dart';
import '../../util/components_theme/box.dart';

class AddNewsPage extends StatefulWidget {
  AddNewsPage({Key? key}) : super(key: key);

  @override
  _AddNewsPageState createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _imageUrl = '';
  String _description = '';
  File? _imageFile;

  FirebaseAuthMethods authMethods = FirebaseAuthMethods();

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
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
      final storageReference = FirebaseStorage.instance.ref().child('${userID}/news').child("post_$postID");
      await storageReference.putFile(_imageFile!);
      final downloadUrl = await storageReference.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        _imageFile != null)
    {
      _formKey.currentState!.save();
      await _uploadImage();
      String userID = await authMethods.getUserId();
      final newss = News(
        userID,
        _title,
        _imageUrl,
        _description,
        DateTime.now(),
      );
      try {
        await newss.addToFirestore();
        showSnackBar(context, "News added succesfully!");
        Navigator.pop(context);
      } catch (e) {
        throw Exception('Error adding news to Firestore: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: addPagesBackgroundColor,
      appBar: AppBar(
        title: Text('Add News'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: addPageInputStyle("Title"),
                cursorColor: inputDecorationColor,
                maxLength: 30,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    showSnackBar( context, 'Please enter a title.');
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () { _pickImage(); },
                child: _imageFile == null
                    ? Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Icon(Icons.add_a_photo),
                      )
                    : Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: addPageInputStyle("Description"),
                cursorColor: inputDecorationColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    showSnackBar(context, 'Please enter a description.');
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor
                ),
                onPressed: _submitForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
