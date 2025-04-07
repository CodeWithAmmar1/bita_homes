import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import 'package:testappbita/controller/mqtt_controller.dart';

class TemperatureDialog extends StatefulWidget {
  @override
  _TemperatureDialogState createState() => _TemperatureDialogState();
}

class _TemperatureDialogState extends State<TemperatureDialog> {
  late int temperature;
  final MqttController mqttController = Get.find<MqttController>();

  @override
@override
void initState() {
  super.initState();
  // Convert received value to int, default to 25 if invalid
  temperature = int.tryParse(mqttController.receivedData['temp1sp'].toString()) ?? 25;
}


  /// **Update UI and send new `temp1sp` value to MQTT**
  void updateTemperature(int newTemp) {
    setState(() {
      temperature = newTemp; // ✅ Update UI
    });

    // ✅ Ensure RxMap is updated correctly
    mqttController.receivedData['temp1sp'] = newTemp;
    mqttController.receivedData.refresh(); // ✅ Notify listeners

    // ✅ Send updated full JSON via MQTT
    mqttController.sendData(Map<String, dynamic>.from(mqttController.receivedData));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Dialog Container
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/pump.png',
                      height: 80,
                    ),
                    SizedBox(height: 10),
                                      Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.white),
                          onPressed: () {
                            if (temperature > 10) {
                              updateTemperature(temperature - 1);
                            }
                          },
                        ),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: Text(
                            "$temperature°C",
                            key: ValueKey<int>(temperature),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            if (temperature < 35) {
                              updateTemperature(temperature + 1);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  
                ),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Function to show the dialog
void showTemperatureDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => TemperatureDialog(),
  );
}
