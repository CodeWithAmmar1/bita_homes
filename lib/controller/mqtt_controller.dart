import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testappbita/Views/zone_master/pannel/custom_bottom_Cfm.dart';
import 'package:testappbita/Views/zone_master/theme/theme.dart';
import 'package:testappbita/services/firebase_service.dart';

class MqttController extends GetxController {
  RxString topicSSIDvalue = "".obs;
  var isSummer = false.obs;
  var deviceTopic = "".obs;
  var selectedDateTime = DateTime.now().obs;
  var isOn = true.obs;
  var currentValue = 50.0.obs;
  var temperature = 30.0.obs;
  var isThermostatContainerVisible = false.obs;
  var isCalendarVisible = true.obs;
  var thermostatTemperature = 20.0.obs;
  var mqttBroker = "192.168.18.112".obs;
  var clientId = "".obs;
  var port = 1883.obs;
  var receivedMessage = "".obs;
  var lastDamperValue = 24.0.obs;
  var packetId = 0.obs;
  var isConnected = false.obs;
  var message = "".obs;

  var correctPassword = "1234567".obs;
  var isPasswordCorrect = false.obs;
  var deviceTemperatures = <String, double>{}.obs;
  var deviceSwitchStates = <String, String>{}.obs;

  Timer? lockTimer;
  MqttServerClient? client;

  @override
  void onInit() {
    log("MQTT controller onit");
    super.onInit();
    _setupMqttClient();
    _connectMqtt();
    fetchClientId();
  }

  fetchClientId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      clientId.value = user.uid;
    }
  }

  updatetopicSSIDvalue(value) {
    topicSSIDvalue.value = value;
    update();
  }

  void _setupMqttClient() {
    client = MqttServerClient(mqttBroker.value, clientId.value);
    client?.port = port.value;
    client?.logging(on: true);
    client?.onDisconnected = _onDisconnected;
    client?.onConnected = _onConnected;
    client?.onSubscribed = _onSubscribed;
  }

  void _onDisconnected() {
    log('Disconnected from MQTT broker.');
    isConnected.value = false;
  }

  void _onConnected() {
    log('Connected to Onconnect.');
    isConnected.value = true;

    client?.subscribe('/KRC/#', MqttQos.atLeastOnce);
    client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>>? messages) {
      final MqttPublishMessage msg = messages![0].payload as MqttPublishMessage;
      log('subscribe_____/KRC/$topicSSIDvalue');
      final String topic = messages[0].topic;
      final String message =
          MqttPublishPayload.bytesToStringAsString(msg.payload.message);
      log(topic);
      log("message1");
      receivedMessage.value = message;

      if (topicSSIDvalue != "") {
        log('topicSSIDvalue != ""');
        if (topic == "/KRC/$topicSSIDvalue") {
          log('Message Received on /KRC/$topicSSIDvalue: $message');
          print('Message Received on /KRC/$topicSSIDvalue: $message');
          _handleMessage(message);
        }
      } else {
        log('topicSSIDvalue == ""');
        print('Message Received on /KRC/#: $message');
        _handleMessageDevice(message, topic);
      }
    });
  }

  Future<void> _connectMqtt() async {
    while (true) {
      try {
        log('Attempting to connect...');
        await client?.connect();
        if (client?.connectionStatus?.state == MqttConnectionState.connected) {
          log('Connected to MQTT broker.');
          isConnected.value = true;
          break;
        } else {
          log('Connection failed: ${client?.connectionStatus?.state}');
        }
      } catch (e) {
        log('Exception while connecting: $e');
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void updateTemperature(String topic, double temp) {
    deviceTemperatures[topic] = temp;
    deviceTemperatures.refresh();
  }

  void switchtoggle(String topicid, String dampertsw) {
    deviceSwitchStates[topicid] = dampertsw;
    deviceSwitchStates.refresh();
  }

  void _handleMessageDevice(String message, String topics) async {
   try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String dmptemp = jsonMap['dmptemp'];
      String ip = jsonMap['ip_address'];
      String mac = jsonMap['mac_address'];
      String dampertsw = jsonMap['dampertsw'];
      String topicid = topics.split('/').last;

      log('Updating SharedPreferences with IP and MAC...');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await SharedPreferencesService().updateDeviceData(
        deviceId: prefs.getString('deviceId') ?? "",
        updatedIp: ip,
        updatedMac: mac,
      );
      updateTemperature(topicid, double.parse(dmptemp));
      switchtoggle(topicid, dampertsw);
      log("Updated Switch List: $deviceSwitchStates");
      log("Updated Temperature List: $deviceTemperatures");
      log("here is topic: $deviceTopic");
      log("State temp: $dmptemp");
      log("State ip: $ip"); log("State switch: $dampertsw");
    } catch (e) {
      log("Error parsing message: $e");
    }
  }

  void _handleMessage(String message) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);
      String seasonsw = jsonMap['seasonsw'];
      String dmptemp = jsonMap['dmptemp'];
      String dmptempsp = jsonMap['dmptempsp'];
      String dampertsw = jsonMap['dampertsw'];
      String supcfm = jsonMap['supcfm'];
      String ip = jsonMap['ip_address'];
      String mac = jsonMap['mac_address'];

      log('Updating SharedPreferences with IP and MAC...');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await SharedPreferencesService().updateDeviceData(
        deviceId: prefs.getString('deviceId') ?? "",
        updatedIp: ip,
        updatedMac: mac,
      );

      // Update observable variables
      isOn.value = dampertsw == "1";
      isSummer.value = seasonsw == "1";
      temperature.value = double.parse(dmptemp);
      lastDamperValue.value = double.parse(dmptempsp);
      thermostatTemperature.value = double.parse(dmptempsp);
      currentValue.value = double.parse(supcfm);

      log("State updated: $jsonMap");
    } catch (e) {
      log("Error parsing message: $e");
    }
  }

  Map<String, dynamic> _buildJsonPayload() {
    return {
      "comment": "from Application",
      "seasonsw": isSummer.value ? 1 : 0,
      "dmptempsp": thermostatTemperature.value,
      "dampertsw": isOn.value,
      "supcfm": "$currentValue",
      "dampstate": isOn.value,
    };
  }

  String createjson() {
    final String jsonPayload = jsonEncode(_buildJsonPayload());
    print("JSON Payload: $jsonPayload");
    return jsonPayload;
  }

  void publishMessage(String message) {
    String topic = "/test/$topicSSIDvalue/1";
    if (client != null) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);

      try {
        client!.publishMessage(
          topic,
          MqttQos.atLeastOnce,
          builder.payload!,
          retain: true,
        );
        print('Message published to $topic: $message');
      } catch (e) {
        print('Failed to publish message: $e');
      }
    }
  }


  void publishMessage1(String message, topicssid) {
     String topic = "/test/$topicssid/1";
     log(topic.toString());
     if (client != null) {
       final builder = MqttClientPayloadBuilder();
       builder.addString(message);
 
       try {
         client!.publishMessage(
           topic,
           MqttQos.atLeastOnce,
           builder.payload!,
           retain: true,
         );
         print('Message published to $topic: $message');
       } catch (e) {
         print('Failed to publish message: $e');
       }
     }
   }
  Future<void> showPasswordDialog(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();

    await Get.dialog(
      AlertDialog(
        backgroundColor: ThemeColor().dialogBox,
        title: Text("Enter Password".tr),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(hintText: "Enter Password".tr),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (passwordController.text == correctPassword.value) {
                isPasswordCorrect.value = true;
                startLockTimer();
                Get.back();

                Get.bottomSheet(
                  CustomBottomSheet1(),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                );
              } else {
                Get.snackbar("Error", "Incorrect Password");
              }
            },
            child: Text(
              "Submit".tr,
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "cancel".tr,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void startLockTimer() {
    lockTimer?.cancel();
    lockTimer = Timer(Duration(seconds: 10), () {
      isPasswordCorrect.value = false;
      Get.snackbar("CFM Protection", "Slider locked.",
          backgroundColor: ThemeColor().dialogBox);
    });
  }

  void toggleThermostatSettings() {
    isThermostatContainerVisible.value = !isThermostatContainerVisible.value;
    isCalendarVisible.value = !isCalendarVisible.value;
  }

  void changeDamperValue(double value) {
    lastDamperValue.value = value;
    thermostatTemperature.value = value;
  }

  String selectSeason(var summer) {
    isSummer.value = summer;
    receivedMessage.value = "Season Selected: ${summer ? 'Summer' : 'Winter'}";

    String message =
        "Season Selected: ${summer ? 'Winter' : 'Summer'}"; // This seems to indicate the opposite season, double-check if this is correct.
    message = createjson();
    publishMessage(message);

    return message;
  }

  void showDateTimePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime.value,
      barrierColor: const Color.fromARGB(255, 57, 218, 141),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime.value),
        barrierColor: Colors.greenAccent,
      );

      if (pickedTime != null) {
        selectedDateTime.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        receivedMessage.value =
            "Date & Time: ${selectedDateTime.value.toString()}";
        createjson(); // Publish the complete JSON data
      }
    }
  }
}
