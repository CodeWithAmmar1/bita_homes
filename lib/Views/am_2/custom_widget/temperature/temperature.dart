
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_2/custom_widget/temperature/temperature_widget.dart';
import 'package:testappbita/Views/am_2/custom_widget/temperature/temperatures_settings/discharge_setting.dart';
import 'package:testappbita/Views/am_2/custom_widget/temperature/temperatures_settings/return_setting.dart' show ReturnSetting;
import 'package:testappbita/Views/am_2/custom_widget/temperature/temperatures_settings/suction_setting.dart';
import 'package:testappbita/Views/am_2/custom_widget/temperature/temperatures_settings/supply_setting.dart';
import 'package:testappbita/controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Temperature extends StatelessWidget {
  Temperature({super.key});
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: Get.isDarkMode ? ThemeColor().mode2 :ThemeColor().mode1,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
               
                color: ThemeColor().actual,
                borderRadius: BorderRadius.circular(12),
              ),
              child:  Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.settings,
                    size: 30,
                    color:Get.isDarkMode ? Colors.white :Colors.black,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Temperatures',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                         color:Get.isDarkMode ? Colors.white :Colors.black),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => ReturnSetting());
                },
                child: Obx(
                  () => TemperatureWidget(
                    title: "RETURN",
                    setpoint: _mqttController.temp1.value.toString(),
                    high: _mqttController.temp1setlow.value.toString(),
                    low: _mqttController.temp1sethigh.value.toString(),
                    getColorLogic: (pressure) =>
                        (_mqttController.temp1sethigh.value >=
                                    _mqttController.temp1.value ||
                                _mqttController.temp1setlow.value <=
                                    _mqttController.temp1.value)
                            ? Colors.red
                            : Get.isDarkMode ? Colors.white :Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => SupplySetting());
                },
                child: Obx(
                  () => TemperatureWidget(
                    title: "SUPPLY",
                    setpoint: _mqttController.temp2.value.toString(),
                    high: _mqttController.temp2setlow.value.toString(),
                    low: _mqttController.temp2sethigh.value.toString(),
                    getColorLogic: (pressure) =>
                        (_mqttController.temp2sethigh.value >=
                                    _mqttController.temp2.value ||
                                _mqttController.temp2setlow.value <=
                                    _mqttController.temp2.value)
                            ? Colors.red
                            : Get.isDarkMode ? Colors.white :Colors.black,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => SuctionSetting());
                },
                child: Obx(
                  () => TemperatureWidget(
                    title: "SUCTION",
                    setpoint: _mqttController.temp3.value.toString(),
                    low: _mqttController.temp3sethigh.value.toString(),
                    getColorLogic: (pressure) => _mqttController.temp3.value <=
                            _mqttController.temp3sethigh.value
                        ? Colors.red
                        : Get.isDarkMode ? Colors.white :Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => DischargeSetting());
                },
                child: Obx(
                  () => TemperatureWidget(
                    title: "DISCHARGE",
                    setpoint: _mqttController.temp4.value.toString(),
                    high: _mqttController.temp4setlow.value.toString(),
                    getColorLogic: (pressure) => _mqttController.temp4.value >=
                            _mqttController.temp4setlow.value
                        ? Colors.red
                        : Get.isDarkMode ? Colors.white :Colors.black,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
