import 'package:cameye/AddCam.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPVerification extends StatelessWidget {
  OTPVerification({super.key});
  TextEditingController _otpController = TextEditingController();

  final _emailController = TextEditingController();
  void VerifyOTP() {
    EmailAuth emailAuth = EmailAuth(sessionName: "Verification Session");
    bool res = emailAuth.validateOtp(
        recipientMail: _emailController.text, userOtp: _otpController.text);
    if (res) {
      print("OTP Verified");
    } else {
      print("invalid OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
        centerTitle: true,
        // foregroundColor: Colors.white,
        // backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "A Verification code is sent to your email addres",
            style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Enter Verification code",
            style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              VerifyOTP();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCam(),
                  ));
            },
            style: ButtonStyle(
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
              backgroundColor: const WidgetStatePropertyAll(
                Color.fromARGB(255, 0, 0, 0),
              ),
              minimumSize: const WidgetStatePropertyAll(
                Size(double.infinity, 50),
              ),
            ),
            child: Text(
              "Verify",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
