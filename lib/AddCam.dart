

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, file_names

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cameye/AddUser.dart';
import 'package:cameye/Custom_widgets/CustomFormWidgets.dart';
import 'package:cameye/Firebase.dart';
import 'package:cameye/ListUsers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCam extends StatefulWidget {
  const AddCam({super.key});

  @override
  State<AddCam> createState() => _AddCamState();
}

class _AddCamState extends State<AddCam> {
  final _formKey = GlobalKey<FormState>();
  final _camNameController = TextEditingController();
  final _camIPController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Cam"),
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
                "Add Camera details",
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
                    hintText: "Cam0",
                    icon: Icons.camera_alt_sharp,
                    controller: _camNameController,
                    fieldname: "Camera Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Camera name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomFormField(
                  hintText: "Enter Camera IP address",
                  icon: Icons.camera_front,
                  controller: _camIPController,
                  fieldname: "Cam IP Address",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your camera IP address';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    AuthFunctions.addCam(_camNameController.text,
                        _camIPController.text, context);
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                  backgroundColor: const WidgetStatePropertyAll(
                    Color.fromARGB(255, 0, 0, 0),
                  ),
                  minimumSize: const WidgetStatePropertyAll(
                    Size(250, 50),
                  ),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCam(),
                      ));
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                  backgroundColor: const WidgetStatePropertyAll(
                    Color.fromARGB(255, 0, 0, 0),
                  ),
                  minimumSize: const WidgetStatePropertyAll(
                    Size(150, 50),
                  ),
                ),
                child: Text(
                  "Add Another Cam",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUsers(),
                      ));
                },
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                    backgroundColor: const WidgetStatePropertyAll(
                      Color.fromARGB(255, 0, 0, 0),
                    ),
                    minimumSize: const WidgetStatePropertyAll(Size(150, 50))),
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
