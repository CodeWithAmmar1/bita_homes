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
import 'package:testappbita/controller/switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:testappbita/services/firebase_service.dart';

class MqttController extends GetxController {
  //ZONE MASTER:
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
  RxBool isUserInteracting = false.obs;
  RxString correctPassword = "1234567".obs;
  RxBool isPasswordCorrect = false.obs;
  //CONTROL MASTER:
  RxMap<String, double> deviceTemperatures = <String, double>{}.obs;
  RxMap<String, String> deviceSwitchStates = <String, String>{}.obs;
  var lastCMValue = 24.0.obs;
  var receivedData = {}.obs;
  //AM_2:
var amp1 = 18.obs; //phase3 ka current ampere
  var amp2 = 15.obs; //phase1 ka current ampere
  var amp3 = 13.obs; //phase2 ka current ampere
  var temp1 = 16.obs; //cw in current temp
  var temp2 = 18.obs; //cw out current temp
  var temp3 = 24.obs; //suction current temp
  var temp4 = 80.obs; //discharge ka current temp
  var psig1 = 18.25.obs; //low pressure ka current pressure
  var psig2 = 25.24.obs; //high ka current pressure
  var psig3 = 30.18.obs; //oil pressure ka current pressure
  var temp1setlow = 18.obs; //chill in ka low slider
  var temp2setlow = 25.obs;
  var temp3setlow = 25.obs; //suction ka low slider
  var temp4setlow = 81.obs; //Discharge ka low slider
  var psig1setlow = 17.obs; //low pressure setting ka high slider
  var psig2setlow = 100.obs; //high ka high slider
  var psig3setlow = 70.obs; //oil pressure ka high slider

  var temp1sethigh = 18.obs;
  var temp2sethigh = 18.obs;
  var temp3sethigh = 26.obs; //suction ka high slider
  var temp4sethigh = 82.obs; //Discharge ka high slider
  var psig1sethigh = 18.obs; //low pressure setting ka low slider
  var psig2sethigh = 90.obs; //high ka low slider
  var psig3sethigh = 50.obs; //oil pressure ka low slider

  var amp1high = 30.obs; //phase 1 ko low slider
  var amp2high = 40.obs; //phase 2 ko low slider
  var amp3high = 50.obs; //phase 3 ko low slider
  var amp1low = 35.obs; //phase 1 ka high slider
  var amp2low = 25.obs; //phase 2 ko high slider
  var amp3low = 15.obs; //phase 3 ko high slider
  var comp1status = 1.obs;
  var isOilPressureVisible = false.obs; 
  var isObscured=false.obs;


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
    client =
        MqttServerClient.withPort(mqttBroker.value, clientId.value, port.value);
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
      final String payload =
          MqttPublishPayload.bytesToStringAsString(msg.payload.message);

      log('Message received on topic $topic: $payload');
      receivedMessage.value = payload;

      if (isUserInteracting.value == false) {
        if (topicSSIDvalue.value.isNotEmpty) {
          if (topic == "/KRC/${topicSSIDvalue.value}") {
            if (topicSSIDvalue.value.startsWith("CM2")) {
              onMessageReceived(payload);
            } else if (topicSSIDvalue.value.startsWith("ZMB")) {
              _handleMessage(payload);
            }

            else if (topicSSIDvalue.value.startsWith("AM3")) {
               _handleMessageAm2(payload);
            }
          }
        } else {
          _handleMessageDevice(payload, topic);
        }
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
      client!.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(clientId.value)
          .startClean();

      log("Connecting to MQTT broker...");
      await client!.connect();

      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        log('Connected to MQTT broker.');
        isConnected.value = true;
      } else {
        log('Connection failed: ${client!.connectionStatus!.state}');
        client!.disconnect();
      }
    } catch (e) {
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

      log(lastDamperValue.toString());
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
          retain: false,
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
          retain: false,
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
    lastDamperValue.value = double.parse(value.toStringAsFixed(0));
    thermostatTemperature.value = double.parse(value.toStringAsFixed(0));
    thermostatTemperature.refresh();
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
//AM_2:
  void _handleMessageAm2(String message) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);

      amp1.value = int.tryParse(jsonMap['value0']?.toString() ?? '') ?? 0;
      amp2.value = int.tryParse(jsonMap['value8']?.toString() ?? '') ?? 0;
      amp3.value = int.tryParse(jsonMap['value9']?.toString() ?? '') ?? 0;
      temp1.value = int.tryParse(jsonMap['value1']?.toString() ?? '') ?? 0;
      temp2.value = int.tryParse(jsonMap['value2']?.toString() ?? '') ?? 0;
      temp3.value = int.tryParse(jsonMap['value3']?.toString() ?? '') ?? 0;
      temp4.value = int.tryParse(jsonMap['value4']?.toString() ?? '') ?? 0;

      psig1.value = double.tryParse(jsonMap['value5']?.toString() ?? '') ?? 0.0;
      psig2.value = double.tryParse(jsonMap['value6']?.toString() ?? '') ?? 0.0;
      psig3.value = double.tryParse(jsonMap['value7']?.toString() ?? '') ?? 0.0;

      temp1setlow.value =
          int.tryParse(jsonMap['value10']?.toString() ?? '') ?? 0;
      temp2setlow.value =
          int.tryParse(jsonMap['value11']?.toString() ?? '') ?? 0;
      temp3setlow.value =
          int.tryParse(jsonMap['value12']?.toString() ?? '') ?? 0;
      temp4setlow.value =
          int.tryParse(jsonMap['value13']?.toString() ?? '') ?? 0;

      psig1setlow.value =
          int.tryParse(jsonMap['value14']?.toString() ?? '') ?? 0;
      psig2setlow.value =
          int.tryParse(jsonMap['value15']?.toString() ?? '') ?? 0;
      psig3setlow.value =
          int.tryParse(jsonMap['value16']?.toString() ?? '') ?? 0;

      temp1sethigh.value =
          int.tryParse(jsonMap['value21']?.toString() ?? '') ?? 0;
      temp2sethigh.value =
          int.tryParse(jsonMap['value22']?.toString() ?? '') ?? 0;
      temp3sethigh.value =
          int.tryParse(jsonMap['value23']?.toString() ?? '') ?? 0;
      temp4sethigh.value =
          int.tryParse(jsonMap['value24']?.toString() ?? '') ?? 0;

      psig1sethigh.value =
          int.tryParse(jsonMap['value25']?.toString() ?? '') ?? 0;
      psig2sethigh.value =
          int.tryParse(jsonMap['value26']?.toString() ?? '') ?? 0;
      psig3sethigh.value =
          int.tryParse(jsonMap['value27']?.toString() ?? '') ?? 0;

      amp1high.value = int.tryParse(jsonMap['value28']?.toString() ?? '') ?? 0;
      amp2high.value = int.tryParse(jsonMap['value29']?.toString() ?? '') ?? 0;
      amp3high.value = int.tryParse(jsonMap['value20']?.toString() ?? '') ?? 0;
      amp1low.value = int.tryParse(jsonMap['value17']?.toString() ?? '') ?? 0;
      amp2low.value = int.tryParse(jsonMap['value18']?.toString() ?? '') ?? 0;
      amp3low.value = int.tryParse(jsonMap['value19']?.toString() ?? '') ?? 0;
      comp1status.value =
          int.tryParse(jsonMap['value30']?.toString() ?? '') ?? 0;

      log("Received MQTT Data:");
      log("amp1 = $amp1");
      log("amp2 = $amp2");
      log("amp3 = $amp3");
      log("temp1 = $temp1");
      log("temp2 = $temp2");
      log("temp3 = $temp3");
      log("temp4 = $temp4");
      log("psig1 = $psig1");
      log("psig2 = $psig2");
      log("psig3 = $psig3");
      log("temp1setlow = $temp1setlow");
      log("temp2setlow = $temp2setlow");
      log("temp3setlow = $temp3setlow");
      log("temp4setlow = $temp4setlow");
      log("psig1setlow = $psig1setlow");
      log("psig2setlow = $psig2setlow");
      log("psig3setlow = $psig3setlow");
      log("temp1sethigh = $temp1sethigh");
      log("temp2sethigh = $temp2sethigh");
      log("temp3sethigh = $temp3sethigh");
      log("temp4sethigh = $temp4sethigh");
      log("psig1sethigh = $psig1sethigh");
      log("psig2sethigh = $psig2sethigh");
      log("psig3sethigh = $psig3sethigh");
      log("amp1high = $amp1high");
      log("amp2high = $amp2high");
      log("amp3high = $amp3high");
      log("amp1low = $amp1low");
      log("amp2low = $amp2low");
      log("amp3low = $amp3low");
      log("comp1status = $comp1status");
    } catch (e) {
      log("Error parsing JSON: $e");
    }
  }

  void buildJsonPayload() {
    Map<String, dynamic> jsonPayload = {
      "amp1": amp1.value.toString(),
      "amp2": amp2.value.toString(),
      "amp3": amp3.value.toString(),
      "temp1": temp1.value.toString(),
      "temp2": temp2.value.toString(),
      "temp3": temp3.value.toString(),
      "temp4": temp4.value.toString(),
      "psig1": psig1.value.toString(),
      "psig2": psig2.value.toString(),
      "psig3": psig3.value.toString(),
      "temp1set_LOW": temp1setlow.value.toString(),
      "temp2set_LOW": temp2setlow.value.toString(),
      "temp3set_LOW": temp3setlow.value.toString(),
      "temp4set_LOW": temp4setlow.value.toString(),
      "psig1set_LOW": psig1setlow.value.toString(),
      "psig2set_LOW": psig2setlow.value.toString(),
      "psig3set_LOW": psig3setlow.value.toString(),
      "temp1set_HIGH": temp1sethigh.value.toString(),
      "temp2set_HIGH": temp2sethigh.value.toString(),
      "temp3set_HIGH": temp3sethigh.value.toString(),
      "temp4set_HIGH": temp4sethigh.value.toString(),
      "psig1set_HIGH": psig1sethigh.value.toString(),
      "psig2set_HIGH": psig2sethigh.value.toString(),
      "psig3set_HIGH": psig3sethigh.value.toString(),
      "AMP1_HIGH": amp1high.value.toString(),
      "AMP2_HIGH": amp2high.value.toString(),
      "AMP3_HIGH": amp3high.value.toString(),
      "AMP1_LOW": amp1low.value.toString(),
      "AMP2_LOW": amp2low.value.toString(),
      "AMP3_LOW": amp3low.value.toString(),
      "comp1status": comp1status.value.toString(),
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

void updateChillInlp(double value) {
    temp1sethigh.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //Cw in ka high slider
  void updateChillInhp(double value) {
    temp1setlow.value = value.toInt();
    buildJsonPayload();
    update();
  }


  //Cw out ka low slider
  void updateChillOutlp(double value) {
    temp2sethigh.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //Cw out ka high slider
  void updateChillOuthp(double value) {
    temp2setlow.value = value.toInt();
    buildJsonPayload();
    update();
  }

  void updateSuctionLow(double value) {
    temp3sethigh.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //low pressure ka low slider
  void updateLowPressurelp(double value) {
    psig1sethigh.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //low pressure ka high slider
  void updateLowPressurehp(double value) {
    psig1setlow.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //high pressure ka low slider
  void updateHighPressurelp(double value) {
    psig2sethigh.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //high pressure ka high slider
  void updateHighPressurehp(double value) {
    psig2setlow.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //oil pressure ka low slider
  void updateOilPressurelp(double value) {
    psig3sethigh.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //oil pressure ka high slider
  void updateOilPressurehp(double value) {
    psig3setlow.value = value.toInt();
    buildJsonPayload();
    update();
  }
  //phase 1 ka low slider
  void updatePhase1lp(double value) {
    amp1high.value = value.toInt();
    buildJsonPayload();
    update();
  }
  //phase 1 ka high slider
  void updatePhase1hp(double value) {
    amp1low.value = value.toInt();
    buildJsonPayload();
    update();
  }
  //phase 2 ka low slider
  void updatePhase2lp(double value) {
    amp2high.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //phase 2 ka high slider
  void updatePhase2hp(double value) {
    amp2low.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //phase 3 ka low slider
  void updatePhase3lp(double value) {
    amp3high.value = value.toInt();
    buildJsonPayload();
    update();
  }

  //phase 3 ka high slider
  void updatePhase3hp(double value) {
    amp3low.value = value.toInt();
    buildJsonPayload();
    update();
  }


  

  void updateDischargeHigh(double value) {
    temp4setlow.value = value.toInt();
    buildJsonPayload();
    update();
  }

//CONTROL:
  void onMessageReceived(String messages) {
    try {
      Map<String, dynamic> data = jsonDecode(messages);
      receivedData.value = data; // ✅ Update global state
      print("✅ Received MQTT Data: $data");

      final switchController = Get.find<SwitchCardController>();

      bool updated = false;

      if (data.containsKey('fansw')) {
        bool fanSwitch = data['fansw'] == 1;
        if (switchController.switchCards[0].status != fanSwitch) {
          switchController.switchCards[0].status = fanSwitch;
          updated = true;
        }
      }

      if (data.containsKey('fanstate')) {
        switchController.switchCards[0].actualState = data['fanstate'] == 1;
        updated = true;
      }

      if (data.containsKey('pumpsw')) {
        bool pumpSwitch = data['pumpsw'] == 1;
        if (switchController.switchCards[1].status != pumpSwitch) {
          switchController.switchCards[1].status = pumpSwitch;
          updated = true;
        }
      }

      if (data.containsKey('pumpstate')) {
        switchController.switchCards[1].actualState = data['pumpstate'] == 1;
        updated = true;
      }

      if (data.containsKey("switches") && data["switches"] is List) {
        for (var switchData in data["switches"]) {
          if (switchData is Map<String, dynamic>) {
            int index = switchData["switch_index"] ?? -1;
            bool state = (switchData["switch_state"] ?? 0) == 1;

            if (index >= 0 && index < switchController.switchCards.length) {
              switchController.switchCards[index].status = state;
              updated = true;
            }
          }
        }
      }

      // Refresh UI only if there were updates
      if (updated) {
        switchController.switchCards.refresh();
        print("🚀 UI Updated with new switch states!");
      }
    } catch (e) {
      print("❌ Error processing MQTT message: $e");
      print("📩 Raw message: $message");
    }
  }

  void sendData(Map<String, dynamic> receivedData,
      {int? switchIndex, int? switchState}) {
    Map<String, dynamic> jsonData = {
      "coolmastersw": receivedData["coolmastersw"] ?? 1,
      "temp1": receivedData["temp1"] ?? 23,
      "temp1sp": receivedData["temp1sp"] ?? 28,
      "fansw": receivedData["fansw"] ?? 1,
      "fanstate": receivedData["fanstate"] ?? 1,
      "fanspeed": receivedData["fanspeed"] ?? 2,
      "pumpsw": receivedData["pumpsw"] ?? 1,
      "pumpstate": receivedData["pumpstate"] ?? 1,
      "waterlevel": receivedData["waterlevel"] ?? 45,
      "waterlevelsp": receivedData["waterlevelsp"] ?? 50,
    };

    if (switchIndex != null && switchState != null) {
      bool switchFound = false;

      for (var switchItem in jsonData["switches"]) {
        if (switchItem["switch_index"] == switchIndex) {
          switchItem["switch_state"] = switchState;
          switchFound = true;
          break;
        }
      }

      if (!switchFound) {
        jsonData["switches"]
            .add({"switch_index": switchIndex, "switch_state": switchState});
      }
    }

    String jsonString = jsonEncode(jsonData);
    print("📤 Sending MQTT Message: $jsonString");

    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonString);

    if (builder.payload == null || builder.payload!.isEmpty) {
      print("❌ MQTT Payload is empty! Message not sent.");
      return;
    }

    client?.publishMessage("/test/${topicSSIDvalue.value}/1",
        MqttQos.atMostOnce, builder.payload!);
    print("✅ MQTT Message Sent Successfully!");
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
