
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:testappbita/Views/control_master/water_indicator/level.dart';
import 'package:testappbita/controller/mqtt_controller.dart';
import 'package:testappbita/controller/switch_controller.dart';

class CMPannel extends StatefulWidget {
  const CMPannel({super.key});

  @override
  _CMPannelState createState() => _CMPannelState();
}

class _CMPannelState extends State<CMPannel> {


  void updateTemperature(int newTemp) {
    setState(() {
      temperature = newTemp; // ✅ Update UI
    });

    // ✅ Ensure RxMap is updated correctly
    mqttController.receivedData['temp1sp'] = newTemp;

    mqttController.receivedData.refresh(); // ✅ Notify listeners

    // ✅ Send updated full JSON via MQTT
    mqttController
        .sendData(Map<String, dynamic>.from(mqttController.receivedData));
  }

  final MqttController mqttController = Get.put(MqttController());
  int temperature = 10;
  late Stream<String> _timeStream;
  @override
  void initState() {
    super.initState();
    _timeStream = Stream.periodic(Duration(seconds: 1), (_) {
      return '${DateFormat('EEEE').format(DateTime.now())}\n${DateFormat('hh:mm:ss a').format(DateTime.now())}';
    });
   }
 @override
  void dispose() {
    super.dispose();
    mqttController.updatetopicSSIDvalue("");
  }
  final SwitchCardController switchController = Get.put(SwitchCardController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar( automaticallyImplyLeading: false,
          backgroundColor:  Color(0xFF24C48E),
          title: Row(
            
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ MQTT Connection Status & Title
              Text(
                "CONTROL MASTER",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              StreamBuilder<String>(
                stream: _timeStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return SizedBox.shrink();
                  List<String> parts = snapshot.data!.split('\n');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        parts[0],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        parts[1],
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: Get.width * 0.03, right: Get.width * 0.03),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 198, 198, 199),

                  border: Border.all(
                      color: const Color.fromARGB(255, 198, 198, 199),
                      width: 11), // Green border
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                          size: Get.height * 0.30,
                          angleRange: 260,
                          startAngle: 140,
                          customWidths: CustomSliderWidths(
                            trackWidth: Get.width * 0.008,
                            progressBarWidth: Get.width * 0.010,
                            handlerSize: Get.width * 0.030,
                          ),
                          customColors: CustomSliderColors(
                            trackColor: Colors.grey[300]!,
                            progressBarColors: [
                               Color(0xFF24C48E),
                               Color(0xFF24C48E)
                            ],
                            dotColor:  Color(0xFF24C48E),
                          ),
                        ),
                        min:
                            (mqttController.lastCMValue.value < 10) ? 0 : 0,
                        max: 35,
                        initialValue: temperature.toDouble(),
                        onChange: (double value) {
                          setState(() {
                            temperature = value.toInt();
                          });
                        },
                        onChangeEnd: (double value) {
                          updateTemperature(value.toInt());
                        },
                      ),
                      Container(
                        width: Get.width * 0.48,
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
                              height: Get.height * 0.070,
                            ),
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: mqttController.isConnected.value
                                  ?  Color(0xFF24C48E)
                                  : Colors.red,
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            SizedBox(
                              // height: 90,
                              height: Get.height * 0.08,
                              child: Text(
                                "${mqttController.receivedData['temp1sp'] ?? '--'}°C",
                                style: TextStyle(
                                  fontFamily: 'DS-Digital',
                                  fontSize: Get.width * 0.10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'S.P Temp  ',
                                  style: TextStyle(
                                    fontSize: Get.width * 0.037,
                                    color:
                                        mqttController.lastCMValue.value < 4
                                            ? Colors.red
                                            : Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  "${mqttController.receivedData['temp1'] ?? '--'}°C",
                                  style: TextStyle(
                                    fontSize: Get.width * 0.050,
                                    color:
                                        mqttController.lastCMValue.value < 4
                                            ? Colors.red
                                            : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: Get.height * 0.36, bottom: Get.height * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 3,
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.14,
                                    vertical: Get.height * 0.001),
                              ),
                              onPressed: () {
                                if (temperature > 0) {
                                  updateTemperature(temperature - 1);
                                }
                              },
                              child: Icon(Icons.remove, color:  Color(0xFF24C48E)),
                            ),
                            SizedBox(
                                width: Get.width *
                                    0.09), // Spacing between buttons
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 3,
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.14,
                                    vertical: Get.height * 0.001),
                              ),
                              onPressed: () {
                                if (temperature < 35) {
                                  updateTemperature(temperature + 1);
                                }
                              },
                              child: Icon(Icons.add, color:  Color(0xFF24C48E)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // SizedBox(
            //   height: Get.height * 0.009,
            // ),
            WaterLevelContainer()
          ],
        ),
        bottomNavigationBar: Container(
          height: Get.height * 0.09,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(Get.width * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Obx(() {
                      bool isOn = switchController.switchCards[0].status;
                      return Column(
                        children: [
                          Obx(() {
                            bool isOn = switchController.switchCards[0].status;
                            return CircleAvatar(
                              backgroundColor:
                                  isOn ?  Color(0xFF24C48E) : Colors.grey,
                              radius: 15
                              ,
                              child: IconButton(
                                icon: Center(
                                  child: Icon(
                                    LucideIcons.power,
                                    color: Colors.black,
                                    size: Get.width * 0.04,
                                  ),
                                ),
                                onPressed: () {
                                  switchController.toggleSwitch(0);
                                },
                              ),
                            );
                          }),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(Get.width * 0.009),
                                child: Text(
                                  "Fan Controller",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Get.width * 0.030),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    }),
                  ],
                ),
                Row(
                  children: [
                    Obx(() {
                      bool isOn = switchController.switchCards[1].status;
                      return Column(
                        children: [
                          Obx(() {
                            bool isOn = switchController.switchCards[1].status;
                            return CircleAvatar(
                              backgroundColor:
                                  isOn ?  Color(0xFF24C48E) : Colors.grey,
                              radius: 15,
                              child: IconButton(
                                icon: Icon(
                                  LucideIcons.power,
                                  color: Colors.black,
                                  size: Get.width * 0.04,
                                ),
                                onPressed: () {
                                  switchController.toggleSwitch(1);
                                },
                              ),
                            );
                          }),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(Get.width * 0.009),
                                child: Text(
                                  "Pump Controller",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Get.width * 0.030),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
