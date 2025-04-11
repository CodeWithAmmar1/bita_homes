import 'dart:math';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_2/custom_widget/amperes/ampere_container.dart';
import 'package:testappbita/Views/am_2/custom_widget/pressure/pressure_container.dart';
import 'package:testappbita/controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:testappbita/utils/theme/theme_controller.dart';
import 'custom_widget/temperature/temperature_container.dart';

class Dashboardam2 extends StatefulWidget {
  const Dashboardam2({super.key});
  @override
  State<Dashboardam2> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboardam2> {
  final ThemeController themeController=Get.find<ThemeController>();
  final MqttController _mqttController = Get.put(MqttController());
  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    return Obx(() {
      return Scaffold(
        backgroundColor: Get.isDarkMode ? ThemeColor().mode2 :ThemeColor().mode1,
        body: SingleChildScrollView(
          child: Container(color:Get.isDarkMode ? ThemeColor().mode2 :ThemeColor().mode1,
            child: Column(
              children: [
                AppBar(backgroundColor: ThemeColor().actual,
                  
                   automaticallyImplyLeading: false,
                  title:  Text(
                    "Alert Master",
                    style: TextStyle( color:Get.isDarkMode ? Colors.black :Colors.white,),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon:  Icon(Icons.notifications,
                          color:Get.isDarkMode ? Colors.black :Colors.white),
                      onPressed: () {
                        // Get.to(() => NotificationScreen());
                      },
                    ),
                   
                    
                  ],
                ),
                SizedBox(height: Get.height * 0.012),
                Center(
                  child: Container(
                    height: Get.height * 0.08,
                    width: Get.width * 0.95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color:Get.isDarkMode ? ThemeColor().mode2 :ThemeColor().mode1,
                     
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                            "Compressor Status",
                            style: TextStyle(
                              fontSize: 18,
                              color:Get.isDarkMode ? Colors.white :Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _mqttController.comp1status.value == 0
                                ? 'ON'
                                : 'OFF',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: _mqttController.comp1status.value == 0
                                  ? Colors.green
                                  : Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Get.isDarkMode ? ThemeColor().mode2 :ThemeColor().mode1,
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      TemperatureContainer(),
                      PressureContainer(),
                      AmpereContainer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
