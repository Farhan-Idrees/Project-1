// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:io';
import 'package:cameye/Custom_widgets/CustomFormWidgets.dart';
import 'package:cameye/ListUsers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class AddUsers extends StatefulWidget {
  const AddUsers({super.key});

  @override
  State<AddUsers> createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _relationController = TextEditingController();

  bool loading = false;
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = null;
      }
    });
  }

  Future<void> uploadAndVerify(
      String name, String relation, BuildContext context) async {
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select an image')));
      return;
    }
    User? users = FirebaseAuth.instance.currentUser;

    try {
      setState(() {
        loading = true; // Start loading
      });

      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref("User Photo")
          .child(name)
          .putFile(_image!);

      String url = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(users!.uid)
          .collection('Authorized Users')
          .doc(name)
          .set({
        "Name": name,
        "Relation": relation,
        "Image": url,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User added successfully')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ListUsers(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add user: $e')));
    } finally {
      setState(() {
        loading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Users"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                "Add Users in your Trust Circle",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomFormField(
                        hintText: "Enter Authorize user Name",
                        icon: Icons.person,
                        controller: _nameController,
                        fieldname: "Authorize User Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Authorize user Name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomFormField(
                        hintText: "Enter user relation",
                        icon: Icons.person_add_alt_outlined,
                        controller: _relationController,
                        fieldname: "Relation",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter authorize user relation';
                          }
                          return null;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: _image != null
                          ? CircleAvatar(
                              radius: 75,
                              backgroundImage: FileImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 75,
                              child: Icon(
                                Icons.person,
                                size: 75,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Upload Authorize user photo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        alignment: Alignment.center,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          uploadAndVerify(_nameController.text.toString(),
                              _relationController.text.toString(), context);
                        }
                      },
                      child: loading
                          ? SpinKitThreeBounce(
                              color: Colors.white,
                            )
                          : Text(
                              "Add User",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
