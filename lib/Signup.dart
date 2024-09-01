import 'dart:io';

import 'package:cameye/CustomFormWidgets.dart';
import 'package:cameye/Firebase.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //Controller For SignUp form
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _imageController = TextEditingController();
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Center(
                child: Text(
                  "CamEye",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: GestureDetector(
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
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      CustomFormField(
                        hintText: "Enter your first name",
                        icon: Icons.person,
                        controller: _firstNameController,
                        fieldname: "First Name",
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your First Name';
                          } else if (value.contains(RegExp(r'[0-9]'))) {
                            return 'Please enter your valid First Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFormField(
                        hintText: "Enter your last name",
                        icon: Icons.person,
                        controller: _lastNameController,
                        fieldname: "Last Name",
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Last Name';
                          } else if (value.contains(RegExp(r'[0-9]'))) {
                            return 'Please enter your valid Last Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFormField(
                        hintText: "xyz@gmil.com",
                        icon: Icons.mail,
                        controller: _emailController,
                        fieldname: "E-mail",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!value.contains(RegExp(r'[@]'))) {
                            return "Please enter your valid email contain '@'";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFormField(
                        hintText: "03XXXXXXXXX ",
                        icon: Icons.phone,
                        controller: _phoneController,
                        fieldname: "Phone Number",
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (!RegExp(r'^03\d{9}$').hasMatch(value)) {
                            return "Please enter a valid Pakistani phone number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFormField(
                        hintText: "Enter your strong passsword",
                        icon: Icons.person,
                        controller: _passwordController,
                        fieldname: "Password",
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (!RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%?&])[A-Za-z\d@$!%?&]{12,}$')
                              .hasMatch(value)) {
                            return 'Password must contain at least 12 characters, \nincluding an uppercase and a lowercase letter, \na number, and one special character.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.black),
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  AuthFunctions.signUp(
                                      _firstNameController.text,
                                      _lastNameController.text,
                                      _emailController.text,
                                      _phoneController.text,
                                      _passwordController.text,
                                      _image!.path,
                                      context);
                                }
                              },
                              child: const Text(
                                "SignUp",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
