// ignore_for_file: unnecessary_import, depend_on_referenced_packages, prefer_const_constructors, file_names, unused_import

import 'package:cameye/AddDetails.dart';
import 'package:cameye/CustomFormWidgets.dart';
import 'package:cameye/Firebase.dart';
import 'package:cameye/ForgetPassword.dart';
import 'package:cameye/Signup.dart';
import 'package:cameye/TermsConditions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isChecked = false;
  bool loading = false;
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
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
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CustomFormField(
                        hintText: "Enter your email",
                        icon: Icons.person,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        fieldname: "Email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomFormField(
                        hintText: "Enter your password",
                        icon: Icons.password,
                        controller: _passwordController,
                        fieldname: "Password",
                        obsecuretxt: obscureText,
                        suffixicn: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: obscureText
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: isChecked,
                              activeColor: Colors.blue,
                              tristate: false,
                              onChanged: (newBool) {
                                setState(() {
                                  isChecked = newBool!;
                                });
                              }),
                          Text("I have agrred your "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TermsAndConditions(),
                                  ));
                            },
                            child: Text(
                              "tems & conditions.",
                              style: TextStyle(
                                  color: Colors.indigoAccent, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgetPassword(),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "forget password",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 18),
                            ),
                          ))
                    ],
                  ),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (isChecked) {
                            setState(() {
                              loading = true;
                            });
                            await AuthFunctions.login(_emailController.text,
                                _passwordController.text, context);
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      },
                      child: loading
                          ? SpinKitThreeInOut(
                              color: Colors.white,
                            )
                          : Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ));
                      },
                      child: Text(
                        "Signup",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
