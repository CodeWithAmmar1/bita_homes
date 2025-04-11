import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Pressurewidget extends StatelessWidget {
  final String title;
  final String setpoint;
  final String? high;
  final String? low;
  final Color Function(double pressure)? getColorLogic;
  const Pressurewidget({
    super.key,
    required this.title,
    required this.setpoint,
    this.high,
    this.low,
    this.getColorLogic,
  });

  @override
  Widget build(BuildContext context) {
    double pressure = double.parse(setpoint);
    Color pressureColor =
        getColorLogic != null ? getColorLogic!(pressure) : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: Get.width * 0.49,
        width: Get.width * 0.4,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? ThemeColor().mode2Sec :ThemeColor().mode1Sec,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:Get.isDarkMode ? Colors.white :Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: Get.height * 0.039),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.052,
                  width: Get.width * 0.12,
                  child: CircularProgressIndicator(
                    value: (double.parse(setpoint) / 1000),
                    strokeWidth: 4,
                    backgroundColor: Colors.grey[500],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>( Color(0xFF24C456)),
                  ),
                ),
                Text(
                  "${(double.parse(setpoint)).toInt()} P",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: pressureColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.04),
            if (low != null || high != null)
              Container(
                width: Get.width * 1,
                height: Get.height * 0.055,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:ThemeColor().actual,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: (low != null && high != null)
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      if (low != null)
                        Row(
                          children: [
                             Text('Low: ',
                                style: TextStyle( color:Get.isDarkMode ? Colors.white :Colors.black,
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                            Text(low!, style:  TextStyle( color:Get.isDarkMode ? Colors.white :Colors.black,fontSize: 13)),
                          ],
                        ),
                      if (high != null)
                        Row(
                          children: [
                             Text('High: ',
                                style: TextStyle( color:Get.isDarkMode ? Colors.white :Colors.black,
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                            Text(high!, style:  TextStyle( color:Get.isDarkMode ? Colors.white :Colors.black,fontSize: 13)),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
