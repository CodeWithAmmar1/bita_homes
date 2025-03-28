import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:testappbita/controller/mqtt_controller.dart';
import 'package:testappbita/Views/pannel/custom_bottom.dart';

class Pannel extends StatefulWidget {
  const Pannel({super.key});

  @override
  _PannelState createState() => _PannelState();
}

late String deviceName;

class _PannelState extends State<Pannel> {
  void _showBottomSheet(String title) {
    Get.bottomSheet(
      CustomBottomSheet(),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    deviceName = Get.arguments?["name"] ?? "Unknown Device";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mqttcontroller.updatetopicSSIDvalue("");
  }

  final MqttController _mqttcontroller = Get.put(MqttController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Color(0xFF24C48E),
          centerTitle: true,
          title: Text("ZONE MASTER ( ${deviceName.toUpperCase()} )"),
          //     Text(
          //   _mqttcontroller.topicSSIDvalue.value,
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),

          automaticallyImplyLeading: false,
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20),
          //     child: Container(
          //       height: 20,
          //       width: 20,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(20)),
          //       child: Icon(
          //         Icons.circle,
          //         size: 15,
          //         color: _mqttcontroller.isConnected == true
          //             ? Color(0xFF24C48E)
          //             : _mqttcontroller.isConnected == false
          //                 ? Colors.red
          //                 : Colors.grey,
          //       ),
          //     ),
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                          size: Get.height * 0.35,
                          angleRange: 300,
                          startAngle: 120,
                          customWidths: CustomSliderWidths(
                            trackWidth: Get.width * 0.008,
                            progressBarWidth: Get.width * 0.008,
                            handlerSize: Get.width * 0.025,
                          ),
                          customColors: CustomSliderColors(
                            trackColor: Colors.grey[300]!,
                            progressBarColors: [
                              Color(0xFF24C48E),
                              Color(0xFF24C48E)
                            ],
                            dotColor: Color(0xFF24C48E),
                          ),
                        ),
                        min:
                            (_mqttcontroller.lastDamperValue.value < 5) ? 0 : 5,
                        max: 35,
                        initialValue: _mqttcontroller.thermostatTemperature.value,
                        onChangeStart: (_) {
                          _mqttcontroller.isUserInteracting.value = true;
                            log("Ignoring MQTT update because user is interacting");
                        },
                        onChange: (double value) {
                          _mqttcontroller.isUserInteracting.value = true;
                          log("Ignoring MQTT update because user is interacting");
                          _mqttcontroller.changeDamperValue(value);
                        },
                        onChangeEnd: (double value) {
                          log("_______________");
                          _mqttcontroller.isUserInteracting.value = false;

                          String message = _mqttcontroller.createjson();
                          _mqttcontroller.publishMessage(message);
                        },
                      ),
                      Container(
                        width: Get.width * 0.6,
                        height: Get.height * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.035,
                            ),
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: _mqttcontroller.isConnected.value
                                  ? Color(0xFF24C48E)
                                  : Colors.red,
                            ),
                            SizedBox(
                              height: Get.height * 0.03,
                            ),
                            SizedBox(
                              // height: 90,
                              height: Get.height * 0.12,
                              child: Text(
                                "${_mqttcontroller.thermostatTemperature.value. round()}°C",
                                style: TextStyle(
                                  fontFamily: 'DS-Digital',
                                  fontSize: Get.width * 0.2,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              _mqttcontroller.lastDamperValue.value < 5
                                  ? "Beca is Off"
                                  : '${"Room Temp.".tr} ${_mqttcontroller.temperature}°C',
                              style: TextStyle(
                                fontSize: Get.width * 0.035,
                                color: _mqttcontroller.lastDamperValue.value < 5
                                    ? Colors.red
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.07,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (_mqttcontroller.lastDamperValue.value > 5) {
                              // _mqttcontroller.isUserInteracting.value = true;
                            log("Ignoring MQTT update because user is interacting");
                            _mqttcontroller.lastDamperValue.value -= 1;
                            _mqttcontroller.changeDamperValue(
                                _mqttcontroller.lastDamperValue.value);
                            _mqttcontroller
                                .publishMessage(_mqttcontroller.createjson());
                                    // _mqttcontroller.isUserInteracting.value = false;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                          padding:
                              EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Color(0xFF24C48E),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          if (_mqttcontroller.lastDamperValue.value < 35) {
                                // _mqttcontroller.isUserInteracting.value = true;
                            log("Ignoring MQTT update because user is interacting");
                            _mqttcontroller.lastDamperValue.value += 1;
                            _mqttcontroller.changeDamperValue(
                                _mqttcontroller.lastDamperValue.value);
                            _mqttcontroller
                                .publishMessage(_mqttcontroller.createjson());
                                //  _mqttcontroller.isUserInteracting.value = false;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                          padding:
                              EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Color(0xFF24C48E),
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "${"Mode".tr}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF24C48E),
                              ),
                            ),
                            TextSpan(text: "\n"),
                            TextSpan(
                              text: !_mqttcontroller.isSummer.value
                                  ? "summer".tr
                                  : "winter".tr,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "${"CFM".tr}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF24C48E),
                              ),
                            ),
                            TextSpan(text: "\n"),
                            TextSpan(
                              text:
                                  "${_mqttcontroller.currentValue.toStringAsFixed(0)}%",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 80,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    bool newValue = !_mqttcontroller.isOn.value;
                    _mqttcontroller.isOn.value = newValue;
                    String message = _mqttcontroller.createjson();
                    _mqttcontroller.publishMessage(message);
                  },
                  child: _buildIconContainer(
                      Icons.power_settings_new,
                      Colors.black,
                      _mqttcontroller.isOn.value
                          ? Color(0xFF24C48E)
                          : Colors.grey,
                      "Switch",
                      Colors.black),
                ),
                GestureDetector(
                  onTap: () => _showBottomSheet("Season"),
                  child: _buildIconContainer(Icons.dashboard, Color(0xFF24C48E),
                      Colors.grey.shade200, "Season", Colors.black),
                ),
                GestureDetector(
                  onLongPress: () =>
                      _mqttcontroller.showPasswordDialog(context),
                  child: _buildIconContainer(Icons.tune, Colors.grey,
                      Colors.grey.shade200, "CFM", Colors.grey),
                ),
                _buildIconContainer(Icons.calendar_month, Color(0xFF24C48E),
                    Colors.grey.shade200, "Schedule", Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildIconContainer(
    IconData icon, Color iconColor, Color color, String text, Color txtcolor) {
  return Column(
    children: [
      Container(
        height: Get.height * 0.05,
        width: Get.width * 0.1,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Icon(icon, color: iconColor),
      ),
      Text(
        text.tr,
        style: TextStyle(color: txtcolor),
      )
    ],
  );
}
