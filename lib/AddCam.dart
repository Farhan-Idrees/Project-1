// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cameye/AddUser.dart';
import 'package:cameye/customFormField.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCam extends StatefulWidget {
  const AddCam({super.key});

  @override
  State<AddCam> createState() => _AddCamState();
}

class _AddCamState extends State<AddCam> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

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
                    controller: _usernameController,
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
                  controller: _emailController,
                  fieldname: "CamIP",
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
                              builder: (context) => AddUsers(),
                            ),
                          );
                        } else {}
                      },
                      child: Text(
                        "Verify",
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
