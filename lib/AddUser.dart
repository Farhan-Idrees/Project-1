// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cameye/AddCam.dart';
import 'package:cameye/ListUsers.dart';
import 'package:cameye/customFormField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
              SizedBox(
                height: 50,
              ),
              Text(
                "Add Users in your Trust Circle",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomFormField(
                    hintText: "Enter Authorize user Name",
                    icon: Icons.person,
                    controller: _nameController,
                    fieldname: "Authorize User Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Authorize user Name"';
                      }
                      return null;
                    },
                  ),
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
                      return 'Please enter authorize user relation ';
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
                            // color: Colors.grey[700],
                          ))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Upload Authorize user photo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          alignment: Alignment.center),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          UploadVerify(_nameController.text.toString(),
                                  _relationController.text.toString())
                              .then((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListUsers(),
                              ),
                            );
                          });
                        } else {}
                      },
                      child: Text(
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

  UploadVerify(String name, String relation) async {
     UploadData() async {
    Task task = FirebaseStorage.instance
        .ref("User Photo")
        .child(_nameController.text.toString())
        .putFile(_image!);
    TaskSnapshot taskSnapshot = await task;
    String Url = await taskSnapshot.ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection("User Data")
        .doc(_nameController.text.toString())
        .set({
      "Name": _nameController.text.toString(),
      "Relation": _relationController.text.toString(), // fix typo here
      "Image": Url
    });
  }
  }

 
}
