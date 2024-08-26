
import 'package:cameye/firebase_options.dart';
import 'package:cameye/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CamEye());
}

class CamEye extends StatelessWidget {
  const CamEye({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // themeMode: ,
      debugShowCheckedModeBanner: false,
      home: Login(),
);
}
}
