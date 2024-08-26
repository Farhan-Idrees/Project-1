import 'package:cameye/CustomFormField.dart';
import 'package:cameye/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/Logo.jpg"),
                  radius: 60,
                ),
              ),
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
                      hintText: "Enter your phone number",
                      icon: Icons.person,
                      controller: _phoneController,
                      fieldname: "Phone Number",
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone';
                        } else if (!value.contains(RegExp(r'[0-9]'))) {
                          return "Please enter your valid phone number";
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
                        } else if (!value.contains(RegExp(
                            r'^(?=.[a-z])(?=.[A-Z])(?=.\d)(?=.[@$!%?&])[A-Za-z\d@$!-_%?&]{12,}$'))) {
                          return 'Password must contain 12 characters at least \nUppercase and lowercase letter, \nA number and one special character.';
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
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text)
                                    .whenComplete(() async {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .set({
                                      'email': _emailController.text,
                                      'password': _passwordController.text,
                                      'first_name': _firstNameController.text,
                                      'last_name': _lastNameController.text,
                                      'phone_number': _phoneController.text,
                                    }).whenComplete(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login(),
                                        ),
                                      );
                                    });
                                  } on FirebaseAuthException catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                error.message.toString())));
                                  }
                                });
                              } on FirebaseAuthException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(e.message.toString())));
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
);
}
}
