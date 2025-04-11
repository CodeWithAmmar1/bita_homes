import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemperatureWidget extends StatelessWidget {
  final String title;
  final String setpoint;
  final String? high;
  final String? low;
  final Color Function(int temp)? getColorLogic;
  const TemperatureWidget({
    super.key,
    required this.title,
    required this.setpoint,
    this.high,
    this.low,
    this.getColorLogic,
  });

  @override
  Widget build(BuildContext context) {
    int temp = int.parse(setpoint);
    Color pressureColor =
        getColorLogic != null ? getColorLogic!(temp) : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: Get.width * 0.4,
        width: Get.width * 0.45,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: Get.width * 0.11,
                  height: Get.height * 0.0486,
                  child: CircularProgressIndicator(
                    value: (double.parse(setpoint) / 100),
                    strokeWidth: 4,
                    backgroundColor: Colors.white54,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  ),
                ),
                Text(
                  "${(double.parse(setpoint)).toInt()}°C",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: pressureColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.02),
            if (low != null || high != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green.withValues(alpha: 0.8),
                ),
                width: Get.width * 1,
                height: Get.height * 0.055,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (low != null)
                        Row(
                          children: [
                            const Text('Low: ',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                            Text(low!,
                                style: const TextStyle(
                                  fontSize: 13,
                                )),
                          ],
                        ),
                      if (high != null)
                        Row(
                          children: [
                            const Text('High: ',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                            Text(high!,
                                style: const TextStyle(
                                  fontSize: 13,
                                )),
                          ],
                        ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
