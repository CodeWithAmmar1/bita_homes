
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller.dart';

class WaterTank extends StatefulWidget {
  @override
  _WaterTankState createState() => _WaterTankState();
}

class _WaterTankState extends State<WaterTank> with TickerProviderStateMixin {
  late AnimationController _waterLevelController;
  late Animation<double> _waterLevelAnimation;
  final MqttController mqttController = Get.put(MqttController());

  // Reactive variable to track userSetValue based on MQTT data
  RxInt userSetValue = 0.obs;

  double get baseWaterLevel {
    switch (userSetValue.value) {
      case 0:
        return 0.05; // Low (0%)
      case 1:
        return 0.6; // Mid (60%)
      case 2:
        return 0.95; // High (100%)
      default:
        return 0.6; // Default to Mid
    }
  }

  @override
  void initState() {
    super.initState();

    _waterLevelController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
      lowerBound: 0.0,
      upperBound: 0.2,
    )..repeat(reverse: true);

    _waterLevelAnimation =
        _waterLevelController.drive(Tween(begin: 0.0, end: 0.2))
          ..addListener(() {
            setState(() {});
          });

    // Subscribe to MQTT updates
    mqttController.receivedData.listen((data) {
      if (data.containsKey('waterlevel')) {
        userSetValue.value = (data['waterlevel'] as int).clamp(0, 2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      double animatedWaterLevel = baseWaterLevel + _waterLevelAnimation.value;

      return Stack(
        children: [
          Positioned(
            right: 20,
            child: Container(
              width: 50,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black26, width: 2),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: double.infinity,
                  height: 150 * animatedWaterLevel,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    _waterLevelController.dispose();
    super.dispose();
  }
}
