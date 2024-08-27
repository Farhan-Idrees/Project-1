// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cameye/AddCam.dart';
import 'package:cameye/ListUsers.dart';
import 'package:cameye/customFormField.dart';
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
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(
                          Icons.person,
                          size: 75,
                          color: Colors.grey[700],
                        )
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Upload Authorize user photo",
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListUsers(),
                            ),
                          );
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
}
