// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names, use_build_context_synchronously

import 'package:cameye/AddDetails.dart';
import 'package:cameye/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthFunctions {
  // ignore: prefer_final_fields

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Login Function

  static Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AddDetails()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
  // Signup Function

  static Future<void> signUp(
      String Fname,
      String Lname,
      String email,
      String phoneNumber,
      String password,
      BuildContext context //take these values from user by ui
      ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password); //create user

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'first_name': Fname,
        'last_name': Lname,
        'email': email,
        'phone_number': phoneNumber,
        // 'password': password,
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error:$e "),
      ));

      return null;
    }
  }

//Reset Password
  static Future<void> resetPassword(String email, BuildContext context) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Recovery email sent to $email",
            style: const TextStyle(color: Color.fromARGB(255, 235, 236, 240)),
          ),
        ),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }).onError((Error, StackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$Error"),
      ));
    });
  }

  static Future<void> logout(BuildContext context) async {
    await _auth.signOut().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    });
  }
}
