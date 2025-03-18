import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller.dart';

class CustomBottomSheet extends StatelessWidget {
  final MqttController _mqttcontroller = Get.find();

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("season_select".tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => GestureDetector(
                    onTap: () {
                      _mqttcontroller.selectSeason(false);
                    },
                    child: Container(
                      width: 70,
                      height: 40,
                      decoration: BoxDecoration(
                        color: !_mqttcontroller.isSummer.value
                            ? Colors.green
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "summer".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  )),
              SizedBox(width: 10), // Space between buttons
              Obx(() => GestureDetector(
                    onTap: () {
                      _mqttcontroller.selectSeason(true);
                    },
                    child: Container(
                      width: 70,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _mqttcontroller.isSummer.value
                            ? Colors.green
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "winter".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
