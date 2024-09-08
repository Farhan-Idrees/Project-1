import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final onpressed;
  final String text;
  const CustomButton({super.key, required this.onpressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        backgroundColor: const WidgetStatePropertyAll(
          Color.fromARGB(255, 0, 0, 0),
        ),
        minimumSize: const WidgetStatePropertyAll(
          Size(double.infinity, 50),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
