import 'dart:convert';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:testappbita/controller/mqtt_controller.dart';
import 'package:testappbita/model/switch_model.dart';

class SwitchCardController extends GetxController {
  RxList<SwitchCardModel> switchCards = <SwitchCardModel>[].obs;
  final MqttController mqttController = Get.find<MqttController>();

  @override
  void onInit() {
    super.onInit();

    // Initialize switch cards
    switchCards.addAll([
      SwitchCardModel(status: false, actualState: false, title: 'Fan'),
      SwitchCardModel(status: false, actualState: false, title: 'Pump'),
    ]);

    // Listen for MQTT data updates
    mqttController.receivedData.listen((data) {
      print("✅ Received MQTT Data: $data");

      bool updated = false;

      // Update Fan Switch Status (fansw)
      if (data.containsKey('fansw')) {
        bool fanSwitch = data['fansw'] == 1;
        if (switchCards[0].status != fanSwitch) {
          switchCards[0].status = fanSwitch;
          updated = true;
        }
      }

      // Update Fan Actual State (fanstate)
      if (data.containsKey('fanstate')) {
        switchCards[0].actualState = data['fanstate'] == 1;
        updated = true;
      }

      // Update Pump Switch Status (pumpsw)
      if (data.containsKey('pumpsw')) {
        bool pumpSwitch = data['pumpsw'] == 1;
        if (switchCards[1].status != pumpSwitch) {
          switchCards[1].status = pumpSwitch;
          updated = true;
        }
      }

      // Update Pump Actual State (pumpstate)
      if (data.containsKey('pumpstate')) {
        switchCards[1].actualState = data['pumpstate'] == 1;
        updated = true;
      }

      if (updated) {
        switchCards.refresh(); // 🔄 Refresh UI when any change happens
        print("🚀 UI Updated!");
      }
    });
    mqttController.receivedData.listen((data) {
      if (data.containsKey('fanstate')) {
        switchCards[0] = switchCards[0].copyWith(
          actualState: data['fanstate'] == 1,
        );
        update(); // Ensure UI updates
      }
    });
  }

  // Toggle switch (Sends MQTT request but does NOT update UI immediately)
  void toggleSwitch(int index) {
    if (index >= switchCards.length) return;

    // Toggle the status
    switchCards[index] = switchCards[index].copyWith(
      status: !switchCards[index].status,
    );

    update(); // Ensure UI updates
    sendUpdatedState();
  }

  void sendUpdatedState() {
    if (!Get.isRegistered<MqttController>()) return;

    final mqttController = Get.find<MqttController>();

    Map<String, dynamic> data =
        Map<String, dynamic>.from(mqttController.receivedData);

    // Update data with current switch states
    data['fansw'] = switchCards[0].status ? 1 : 0;
    data['pumpsw'] = switchCards[1].status ? 1 : 0;

    mqttController.sendData(data); // Send updated data to MQTT
  }

  // Handle incoming MQTT messages (for complex cases)
  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage?>>? messages) {
    if (messages == null || messages.isEmpty) return;

    final MqttPublishMessage recMessage =
        messages[0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

    if (message.trim().isEmpty) {
      print("⚠️ Received an empty MQTT message.");
      return;
    }

    try {
      Map<String, dynamic> data = jsonDecode(message);
      mqttController.receivedData.value = data;
    } catch (e) {
      print("❌ Error processing MQTT message: $e");
      print("📩 Raw message: $message");
    }
  }
}
