import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function() onTap;
  final String buttonText;
  const Button({super.key, required this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF24C48E),
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
