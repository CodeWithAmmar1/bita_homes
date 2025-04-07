
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:testappbita/controller/mqtt_controller.dart';
import 'package:testappbita/controller/switch_controller.dart'; 

class CustomBottomSheet extends StatelessWidget {
  final MqttController mqttController = Get.find();
  final SwitchCardController switchController = Get.put(SwitchCardController());

  CustomBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Fan Control',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Obx(() {
            bool isOn = switchController.switchCards[0].status;
            return IconButton(
              icon: Icon(
                LucideIcons.power,
                color: isOn ? Colors.green : Colors.red,
                size: 30,
              ),
              onPressed: () {
                switchController.toggleSwitch(0);
              },
            );
          }),
        ],
      ),
    );
  }
}
