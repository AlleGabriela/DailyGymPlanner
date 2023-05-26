import 'dart:io';
import 'package:daily_gym_planner/routes/trainer/news/TrainerHomePage.dart';
import 'package:daily_gym_planner/services/auth_methods.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:daily_gym_planner/util/showSnackBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/news/NewsServices.dart';
import '../../../util/components_theme/box.dart';

class AddNewsPage extends StatefulWidget {
  const AddNewsPage({Key? key}) : super(key: key);

  @override
  AddNewsPageState createState() => AddNewsPageState();
}

class AddNewsPageState extends State<AddNewsPage> {
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
      final storageReference = FirebaseStorage.instance.ref().child('$userID/news').child("post_$postID");
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
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_imageFile != null) {
        await _uploadImage();
        String userID = await authMethods.getUserId();
        final newsAdd = News(
          userID,
          _title,
          _imageUrl,
          _description,
          DateTime.now(),
        );
        try {
          await newsAdd.addToFirestore();
          showSnackBar(context, "News added successfully!");
          Navigator.pop(context);
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => TrainerHome(),
            ),
          );
        } catch (e) {
          throw Exception('Error adding news to db: $e');
        }
      } else {
        showSnackBar(context, 'Please add an image.');
        throw Exception('Image not selected!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: addPagesBackgroundColor,
      appBar: AppBar(
        title: const Text('Add News'),
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
              const SizedBox(height: 16),
              InkWell(
                onTap: () { _pickImage(); },
                child: _imageFile == null
                    ? Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.add_a_photo),
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
              const SizedBox(height: 16),
              TextFormField(
                decoration: addPageInputStyle("Description"),
                cursorColor: inputDecorationColor,
                keyboardType: TextInputType.multiline,
                maxLines: null,
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
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor
                ),
                onPressed: _submitForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
