
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/control_master/water_indicator/water_tank.dart';
import 'package:testappbita/controller/water_controller.dart';

class WaterLevelContainer extends StatelessWidget {
  final WaterLevelController controller = Get.put(WaterLevelController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.03),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 198, 198, 199),
          border: Border.all(
            color: const Color.fromARGB(255, 198, 198, 199),
            width: Get.width * 0.02, // Responsive border width
          ),
          borderRadius: BorderRadius.circular(
              Get.width * 0.04), // Responsive border radius
        ),
        width: Get.width * 0.94, // Responsive width
        height: Get.height * 0.25, // Responsive height
        padding: EdgeInsets.all(Get.width * 0.05), // Responsive padding
        child: Stack(
          children: [
            Positioned(
              top: Get.height * 0.01,
              left: Get.width * 0.08,
              child: Container(
                width: Get.width * 0.2, // Responsive image width
                height: Get.height * 0.15, // Responsive image height
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/pump.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              right: Get.width * 0.2,
              top: Get.height * 0.005,
              child: Container(
                height: Get.height * 0.18, // Responsive height
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTextLabel("HI-"),
                    _buildTextLabel("MID-"),
                    _buildTextLabel("LOW-"),
                  ],
                ),
              ),
            ),
            WaterTank(),
            Positioned(
              bottom: Get.height * 0.00009,
              left: Get.width * 0.05,
              child: Text(
                "WATER LEVEL",
                style: TextStyle(
                  fontSize: Get.width * 0.04, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Get.width * 0.04, // Responsive font size
      ),
    );
  }
}
