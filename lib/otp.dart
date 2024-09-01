import 'package:cameye/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  OTPVerificationScreen({required this.email});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String? _verificationCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Enter the OTP sent to ${widget.email}'),
          VerificationCode(
            length: 6,
            onCompleted: (String value) {
              setState(() {
                _verificationCode = value;
              });
            },
            onEditing: (bool value) {},
          ),
          ElevatedButton(
            onPressed: () async {
              User? user = FirebaseAuth.instance.currentUser;

              if (user != null && user.emailVerified) {
                // User has verified email
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ));
              } else {
                // Handle OTP verification failure
              }
            },
            child: Text('Verify'),
          ),
        ],
      ),
    );
  }
}
