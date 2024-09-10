// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names, use_build_context_synchronously, unused_import, unused_field, file_names, prefer_const_constructors, duplicate_ignore, avoid_returning_null_for_void
// ignore: unused_import
import 'dart:typed_data';
import 'package:cameye/AddCam.dart';
import 'package:cameye/Home.dart';
import 'package:cameye/ListUsers.dart';
import 'package:cameye/Custom_widgets/OTPVerification.dart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cameye/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthFunctions {
  // ignore: prefer_final_fields

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

//Login Function

  static Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
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
      String image,
      BuildContext context //take these values from user by ui
      ) async {
    try {
      UserCredential userCredential =
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
        "image": image
        // 'password': password,
      });

      await userCredential.user?.sendEmailVerification();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddCam(),
          ));
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
          context, MaterialPageRoute(builder: (context) => AddCam()));
    });
  }



// Add Cam
  static Future<void> addCam(
      String Camname, String CamIP, BuildContext context) async {
    try {
      // Get the user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Check if a device with the same name already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('Devices')
          .where('cam_name', isEqualTo: Camname)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If a device with the same name exists, show an error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Device with this name already exists"),
        ));
        return;
      }

      // Create a new document in the devices subcollection
      DocumentReference deviceRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('Devices')
          .doc();

      // Generate a unique ID for the device
      String deviceId = deviceRef.id;

      // Add the device details to the document
      await deviceRef.set({
        'cam_name': Camname,
        'cam_IP': CamIP,
        'device_id': deviceId, // store the unique ID
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Device Added Successfully "),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e "),
      ));
    }
  }
}

