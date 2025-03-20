import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testappbita/Views/pannel/custom_bottom_Cfm.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:testappbita/services/firebase_service.dart';


class MqttController extends GetxController {
  RxString topicSSIDvalue = "".obs;
  RxBool isSummer = false.obs;
  // RxString deviceTopic = "".obs;
  Rx<DateTime> selectedDateTime = DateTime.now().obs;
  RxBool isOn = false.obs;
  RxDouble currentValue = 50.0.obs;
  RxDouble temperature = 30.0.obs;
  RxBool isThermostatContainerVisible = false.obs;
  RxBool isCalendarVisible = true.obs;
  RxDouble thermostatTemperature = 20.0.obs;
  RxString mqttBroker = 'a31qubhv0f0qec-ats.iot.eu-north-1.amazonaws.com'.obs;
  RxString clientId = "".obs;
  RxInt port = 8883.obs;
  RxString receivedMessage = "".obs;
  RxDouble lastDamperValue = 24.0.obs;
  RxInt packetId = 0.obs;
  RxBool isConnected = false.obs;
  RxString message = "".obs;
  
  RxString correctPassword = "1234567".obs;
  RxBool isPasswordCorrect = false.obs;
  RxMap<String, double> deviceTemperatures = <String, double>{}.obs;
  RxMap<String, String> deviceSwitchStates = <String, String>{}.obs;

  MqttServerClient? client;
  Timer? lockTimer;

  @override
  void onInit() {
    log("MQTT Controller Initialized");
    super.onInit();
    fetchClientId();
    _setupMqttClient();
    _connectMqtt();
  }

  void fetchClientId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      clientId.value = user.uid;
    }
  }

  void updatetopicSSIDvalue(String value) {
    topicSSIDvalue.value = value;
    update();
  }

  void _setupMqttClient() {
    client = MqttServerClient.withPort(mqttBroker.value, clientId.value, port.value);
    client?.secure = true;
    client?.keepAlivePeriod = 60;
    client?.setProtocolV311();
    client?.logging(on: false);
    
    client?.onDisconnected = _onDisconnected;
    client?.onConnected = _onConnected;
    client?.onSubscribed = _onSubscribed;
  }

void _onDisconnected() {
  log("Disconnected from MQTT broker. Reconnecting...");
  isConnected.value = false;
  Future.delayed(Duration(seconds: 5), _connectMqtt);
}


  void _onConnected() {
    log('Connected to MQTT broker.');
    isConnected.value = true;
    
    String topic = '/KRC/#';
    client?.subscribe(topic, MqttQos.atLeastOnce);
    client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>>? messages) {
      if (messages == null || messages.isEmpty) return;

      final MqttPublishMessage msg = messages[0].payload as MqttPublishMessage;
      final String topic = messages[0].topic;
      final String payload = MqttPublishPayload.bytesToStringAsString(msg.payload.message);
      
      log('Message received on topic $topic: $payload');
      receivedMessage.value = payload;

      if (topicSSIDvalue.value.isNotEmpty && topic == "/KRC/${topicSSIDvalue.value}") {
        _handleMessage(payload);
      } else {
        _handleMessageDevice(payload, topic);
      }
    });
  }

  void _onSubscribed(String topic) {
    log('Subscribed to topic: $topic');
  }

  Future<void> _connectMqtt() async {
    if (client == null) {
      log("MQTT Client is not initialized!");
      return;
    }

    try {
      log("Loading certificates...");
      final context = SecurityContext.defaultContext;

      final rootCa = await rootBundle.load('asset/root-CA.crt');
      final deviceCert = await rootBundle.load('asset/Temperature.cert.pem');
      final privateKey = await rootBundle.load('asset/Temperature.private.key');

      context.setClientAuthoritiesBytes(rootCa.buffer.asUint8List());
      context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
      context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

      client!.securityContext = context;
      client!.connectionMessage = MqttConnectMessage().withClientIdentifier(clientId.value).startClean();

      log("Connecting to MQTT broker...");
      await client!.connect();

      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        log('Connected to MQTT broker.');
        isConnected.value = true;
      } else {
        log('Connection failed: ${client!.connectionStatus!.state}');
        client!.disconnect();
      }
    } 
    catch (e) {
      log('MQTT client exception: $e');
      client?.disconnect();
    }
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
      // log("here is topic: $deviceTopic");
      log("State temp: $dmptemp");
      log("State ip: $ip");
      log("State switch: $dampertsw");
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

  void    changeDamperValue(double value) {
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
