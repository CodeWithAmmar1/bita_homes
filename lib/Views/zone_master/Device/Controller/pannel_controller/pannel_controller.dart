// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

// class PannelController extends GetxController {
//   // Reactive state variables
//   var isSummer = true.obs;
//   var selectedDateTime = DateTime.now().obs;
//   var isOn = true.obs;
//   var currentRangeValues = const RangeValues(40, 80).obs;
//   var temperature = 30.0.obs;
//   var isThermostatContainerVisible = false.obs;
//   var isCalendarVisible = true.obs;
//   var thermostatTemperature = 20.0.obs;
//   var receivedMessage = "".obs;
//   var isConnected = false.obs;
//   var lastDamperValue = 24.0.obs;
//   var publishStatus = "".obs;
//   var isPasswordCorrect = false.obs;

//   // Other fields
//   String mqttBroker = "test.mosquitto.org";
//   String clientId = "flutter_mqtt_client";
//   int port = 1883;
//   int packetId = 0;
//   Timer? _lockTimer;
//   late MqttServerClient client;

//   // MQTT setup
//   void setupMqttClient() {
//     client = MqttServerClient(mqttBroker, clientId);
//     client.port = port;
//     client.logging(on: true);
//     client.onDisconnected = onDisconnected;
//     client.onConnected = onConnected;
//     client.onSubscribed = onSubscribed;
//   }

//   void onDisconnected() {
//     print('Disconnected from MQTT broker.');
//     isConnected.value = false;
//   }

//   void onConnected() {
//     print('Connected to MQTT broker.');
//     isConnected.value = true;

//     client.subscribe('/KRC/ZMB-AAA017', MqttQos.atLeastOnce);

//     client.updates!.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
//       final MqttPublishMessage msg = c![0].payload as MqttPublishMessage;
//       final String topic = c[0].topic;
//       final String message =
//           MqttPublishPayload.bytesToStringAsString(msg.payload.message);

//       receivedMessage.value = message;

//       if (topic == '/KRC/ZMB-AAA017') {
//         handleReceivedMessage(message);
//       }
//     });
//   }

//   void onSubscribed(String topic) {
//     print('Subscribed to topic: $topic');
//   }

//   void handleReceivedMessage(String message) {
//     Map<String, dynamic> jsonMap = jsonDecode(message);

//     isSummer.value = jsonMap['seasonsw'] == "1";
//     isOn.value = jsonMap['dampertsw'] == "1";

//     temperature.value = double.parse(jsonMap['dmptemp']);
//     thermostatTemperature.value = double.parse(jsonMap['dmptempsp']);
//     lastDamperValue.value = double.parse(jsonMap['dmptempsp']);
//     currentRangeValues.value = RangeValues(
//       20,
//       double.parse(jsonMap['supcfm']),
//     );

//     print("Processed MQTT message: $jsonMap");
//   }

//   Future<void> connectMqtt() async {
//     while (true) {
//       try {
//         print('Attempting to connect...');
//         await client.connect();
//         if (client.connectionStatus?.state == MqttConnectionState.connected) {
//           print('Connected to the MQTT broker.');
//           break;
//         } else {
//           print('Connection failed: ${client.connectionStatus?.state}');
//         }
//       } catch (e) {
//         print('Exception: $e');
//       }
//       await Future.delayed(const Duration(seconds: 5));
//     }
//   }

//   void publishMessage(String topic, String message) {
//     final builder = MqttClientPayloadBuilder();
//     builder.addString(message);

//     try {
//       client.publishMessage(
//         topic,
//         MqttQos.atLeastOnce,
//         builder.payload!,
//         retain: true,
//       );
//       publishStatus.value = 'Message "$message" published successfully.';
//     } catch (e) {
//       publishStatus.value = 'Failed to publish message: $e';
//     }
//   }

//   // JSON payload creation
//   Map<String, dynamic> buildJsonPayload() {
//     return {
//       "seasonsw": isSummer.value ? "1" : "0",
//       "dmptempsp": thermostatTemperature.value.toString(),
//       "dampertsw": isOn.value ? "1" : "0",
//       "supcfm":
//           "${currentRangeValues.value.start.round()}-${currentRangeValues.value.end.round()}",
//       "timesch": selectedDateTime.value.toIso8601String(),
//       "dampstate": isOn.value ? "1" : "0",
//       "packet_id": packetId,
//     };
//   }

//   String createJson() {
//     final jsonPayload = jsonEncode(buildJsonPayload());
//     print("Created JSON: $jsonPayload");
//     return jsonPayload;
//   }

//   void toggleThermostatSettings() {
//     isThermostatContainerVisible.toggle();
//     isCalendarVisible.toggle();
//   }

//   Future<void> showPasswordDialog(BuildContext context) async {
//     final passwordController = TextEditingController();

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Enter Password"),
//         content: TextField(
//           controller: passwordController,
//           obscureText: true,
//           decoration: const InputDecoration(
//             hintText: "Enter password",
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               if (passwordController.text == "1234567") {
//                 isPasswordCorrect.value = true;
//                 _startLockTimer();
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Incorrect Password")),
//                 );
//               }
//               Navigator.of(context).pop();
//             },
//             child: const Text("Submit"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("Cancel"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _startLockTimer() {
//     _lockTimer?.cancel();
//     _lockTimer = Timer(const Duration(seconds: 10), () {
//       isPasswordCorrect.value = false;
//       Get.snackbar("Info", "Slider locked.");
//     });
//   }

//   @override
//   void onClose() {
//     _lockTimer?.cancel();
//     super.onClose();
//   }

//   void selectSeason(bool summer) {
//     isSummer.value = summer;
//     receivedMessage.value = "Season Selected: ${summer ? 'Summer' : 'Winter'}";

//     // Create and publish the JSON payload
//     String message = createJson();
//     publishMessage("/KRC2/some_topic", message);

//     print("Season changed to: ${summer ? 'Summer' : 'Winter'}");
//   }
// }
