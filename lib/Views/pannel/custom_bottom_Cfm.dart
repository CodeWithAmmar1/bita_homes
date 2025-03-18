import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';


class CustomBottomSheet1 extends StatelessWidget {
  final MqttController _mqttcontroller = Get.find();

  CustomBottomSheet1({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.28,
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: Get.height * 0.197,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.srcIn),
                          child: GestureDetector(
                            onLongPress:
                                _mqttcontroller.toggleThermostatSettings,
                            child: Image.asset(
                              "assets/images/damper_vertical.png",
                              width: 60,
                              height: 60,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("supply_cfm".tr,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              _mqttcontroller.currentValue.toStringAsFixed(0),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: _mqttcontroller.isPasswordCorrect.value
                                ? const RoundSliderThumbShape(
                                    enabledThumbRadius: 10.0,
                                  )
                                : SliderComponentShape.noThumb,
                          ),
                          child: Slider(
                            activeColor: ThemeColor().snackBarColor,
                            value: _mqttcontroller.currentValue.value,
                            min: 10,
                            max: 100,
                            divisions: 100,
                            label:
                                _mqttcontroller.currentValue.toStringAsFixed(0),
                            onChanged: _mqttcontroller.isPasswordCorrect.value
                                ? (double value) {
                                    _mqttcontroller.currentValue.value =
                                        double.parse(value.toStringAsFixed(0));
                                  }
                                : null,
                            onChangeEnd: _mqttcontroller.isPasswordCorrect.value
                                ? (double value) {
                                    String message =
                                        _mqttcontroller.createjson();
                                    _mqttcontroller.publishMessage(message);
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
