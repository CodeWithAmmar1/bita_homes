import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:testappbita/Views/qr_code/qr_code_scanner_page.dart';
import 'package:testappbita/Views/weather/weather_cards.dart';
import 'package:testappbita/controller/mqtt_controller.dart';
import 'package:testappbita/Views/pannel/pannel.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:testappbita/controller/opacity_controller/opacity_controller.dart';
import 'package:testappbita/model/user_device_model.dart';
import 'package:testappbita/services/firebase_service.dart';

MqttServerClient? client;

// ignore: must_be_immutable
class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  List<DeviceModel> allDeviceData = [];
  final OpacityController controller = Get.put(OpacityController());
  final MqttController _mqttcontroller = Get.put(MqttController());
  @override
  void initState() {
    super.initState();
    getTaskListner();
  }

  void getTaskListner() {
    SharedPreferencesService().listenToUserDevices().listen((allTask) {
      debugPrint('Received Data: $allTask');
      setState(() {
        allDeviceData = allTask;
      });
    }, onError: (error) {
      debugPrint('Error in Listener: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return RefreshIndicator(
      color: ThemeColor().buttonColor,
      onRefresh: () async {},
      child: Scaffold(
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.grey.shade100,
        appBar: AppBar(
          title: Text(
            'Home Pages',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: Get.isDarkMode ? Colors.black : Colors.grey.shade100,
          iconTheme:
              IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
          actions: [
            CustomIconButton(
                icon: Icons.notifications,
                onPressed: () {
                  // _mqttcontroller.onInit();
                }),
            SizedBox(width: 10),
            CustomIconButton(
              icon: Icons.add,
              onPressed: () => Get.to(() => QRCodeScanner()),
            ),
            SizedBox(width: 15),
          ],
        ),
        body: Column(
          children: [
            WeatherCard(),
            allDeviceData.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.35),
                      child: Text('No Device Found'),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: GridView.builder(
                        itemCount: allDeviceData.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (context, index) {
                          final device = allDeviceData[index];

                          if ((device.deviceId ?? "")
                              .toUpperCase()
                              .startsWith("AM3")) {
                            return Obx(
                              () => Card(
                                color: Theme.of(context).cardColor,
                                elevation: 0,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: isDarkMode
                                        ? Colors.grey.withOpacity(0.2)
                                        : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? 0.1
                                                : 0.2),
                                        blurRadius: 6,
                                        spreadRadius: 2,
                                        offset: Offset(2, 3),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => Pannel(), arguments: {
                                        "name": "${device.deviceName}"
                                      });
                                      _mqttcontroller.updatetopicSSIDvalue(
                                          device.deviceId ?? "");
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: Theme.of(context)
                                              .dialogBackgroundColor,
                                          title: Text(
                                            "delete_device".tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content:
                                              Text("delete_device_prompt".tr),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "cancel".tr,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                SharedPreferencesService()
                                                    .deleteDeviceData(
                                                        deviceId:
                                                            device.deviceId ??
                                                                "");
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "delete".tr,
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5),
                                                child: Container(
                                                  width: 40, // Adjust as needed
                                                  height:
                                                      40, // Adjust as needed
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue
                                                        .shade100, // Light blue shade
                                                    shape: BoxShape
                                                        .circle, // Makes it circular
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .blue, // Light shadow color
                                                        blurRadius:
                                                            10, // Soft blur effect
                                                        spreadRadius: 2,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                      "assets/images/Temp.png",
                                                      width: 35,
                                                      height: 35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  device.deviceName ?? "",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      _mqttcontroller
                                                                  .isConnected ==
                                                              true
                                                          ? 'Online'
                                                          : 'Offline',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: _mqttcontroller
                                                                    .isConnected ==
                                                                true
                                                            ? Colors.green
                                                            : Colors.red,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      device.deviceId ?? "",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Obx(
                            () => Card(
                              color: Theme.of(context).cardColor,
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: isDarkMode
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? 0.1
                                              : 0.2),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                      offset: Offset(2, 3),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => Pannel(), arguments: {
                                      "name": "${device.deviceName}"
                                    });
                                    _mqttcontroller.updatetopicSSIDvalue(
                                        device.deviceId ?? "");
                                  },
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .dialogBackgroundColor,
                                        title: Text(
                                          "delete_device".tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content:
                                            Text("delete_device_prompt".tr),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "cancel".tr,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.color),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              SharedPreferencesService()
                                                  .deleteDeviceData(
                                                      deviceId:
                                                          device.deviceId ??
                                                              "");
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "delete".tr,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, top: 5),
                                              child: Container(
                                                width: 40, // Adjust as needed
                                                height: 40, // Adjust as needed
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .shade100, // Light blue shade
                                                  shape: BoxShape
                                                      .circle, // Makes it circular
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors
                                                          .blue, // Light shadow color
                                                      blurRadius:
                                                          10, // Soft blur effect
                                                      spreadRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/images/damper1.png",
                                                    width: 35,
                                                    height: 35,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Obx(
                                              () => GestureDetector(
                                                onTap: () {
                                                  String deviceId =
                                                      device.deviceId ?? "";
                                                  if (deviceId.isNotEmpty) {
                                                    bool newValue = !_mqttcontroller
                                                            .deviceSwitchStates
                                                            .containsKey(
                                                                deviceId) ||
                                                        _mqttcontroller
                                                                    .deviceSwitchStates[
                                                                deviceId] !=
                                                            "1";
                                                    _mqttcontroller
                                                                .deviceSwitchStates[
                                                            deviceId] =
                                                        newValue ? "1" : "0";
                                                    _mqttcontroller
                                                        .deviceSwitchStates
                                                        .refresh();
                                                    String message =
                                                        jsonEncode({
                                                      "comment":
                                                          "from Application",
                                                      "dampertsw":
                                                          newValue ? "1" : "0",
                                                    });

                                                    log("switch pressed: $newValue");
                                                    _mqttcontroller
                                                        .publishMessage1(
                                                            message, deviceId);
                                                  }
                                                },
                                                child: Container(
                                                  height: Get.height * 0.05,
                                                  width: Get.width * 0.1,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey
                                                          .withValues(
                                                              alpha: 0.2)),
                                                  child: Container(
                                                    height: Get.height * 0.02,
                                                    // width: Get.width * 0.01,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      boxShadow: (_mqttcontroller
                                                                  .deviceSwitchStates
                                                                  .containsKey(
                                                                      device
                                                                          .deviceId) &&
                                                              _mqttcontroller
                                                                          .deviceSwitchStates[
                                                                      device
                                                                          .deviceId] ==
                                                                  "1")
                                                          ? [
                                                              BoxShadow(
                                                                color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        10,
                                                                        238,
                                                                        18)
                                                                    .withOpacity(
                                                                        0.2), // Glow color
                                                                blurRadius:
                                                                    6, // Spread of the glow
                                                                spreadRadius:
                                                                    1, // Intensity of glow
                                                              ),
                                                            ]
                                                          : [],
                                                    ),
                                                    child: Icon(
                                                      Icons.power_settings_new,
                                                      size: 20,
                                                      color: (_mqttcontroller
                                                                  .deviceSwitchStates
                                                                  .containsKey(
                                                                      device
                                                                          .deviceId) &&
                                                              _mqttcontroller
                                                                          .deviceSwitchStates[
                                                                      device
                                                                          .deviceId] ==
                                                                  "1")
                                                          ? Colors.green
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                device.deviceName ?? "",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.color,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    _mqttcontroller
                                                                .isConnected ==
                                                            true
                                                        ? 'Online'
                                                        : 'Offline',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: _mqttcontroller
                                                                  .isConnected ==
                                                              true
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    device.deviceId ?? "",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class CustomIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CustomIconButton(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            isPressed = false;
          });
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPressed
                ? Colors.grey.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2) // Background effect
            ),
        child: Icon(widget.icon,
            color: isPressed
                ? Color(0xFF24C48E)
                : Color(0xFF24C48E)), // Change icon color
      ),
    );
  }
}
