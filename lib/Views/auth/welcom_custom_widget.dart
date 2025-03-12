import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RoundRectangleButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color; 
  final double size;

  const RoundRectangleButton({required this.text, required this.onTap, required this.color, required this.size});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: Get.height*0.063,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25), // Rounded Rectangle Shape
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle( fontSize: Get.height*0.02, color: Colors.white, ),
          ),
        ),
      ),
    );
  }
}