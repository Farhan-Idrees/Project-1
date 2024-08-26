// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cameye/customFormField.dart';
import 'package:flutter/material.dart';

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
        title: Text("Add Details"),
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
                "Add your details",
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
                  child: CustomTextFormField(
                    hintText: "Enter your username",
                    icon: Icons.person,
                    controller: _usernameController,
                    fieldname: "Username",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CircleAvatar(
                foregroundImage: AssetImage("assets/CamEye.png"),
                radius: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Upload your photo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomTextFormField(
                  hintText: "Enter your email",
                  icon: Icons.mail,
                  controller: _emailController,
                  fieldname: "Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              Center(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Enter code",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  keyboardType: TextInputType.number,
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
                              builder: (context) => AddCam(),
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
