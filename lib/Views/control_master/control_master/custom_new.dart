
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller.dart';
import 'package:testappbita/controller/switch_controller.dart';

class CustomBottomSheet1 extends StatelessWidget {
  final MqttController mqttController = Get.find();
  final SwitchCardController switchController = Get.put(SwitchCardController());

  CustomBottomSheet1({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pump Controller',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Obx(() => Row(
                children: [
                  SizedBox(width: 10),
                  Switch(
                    value: switchController.switchCards[1].status,
                    onChanged: (value) {
                      switchController.toggleSwitch(1);
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
