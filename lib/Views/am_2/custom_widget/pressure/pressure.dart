import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_2/custom_widget/pressure/pressure_widget.dart';
import 'package:testappbita/Views/am_2/custom_widget/pressure/pressures_setting/discharge_pressure_setting.dart';
import 'package:testappbita/Views/am_2/custom_widget/pressure/pressures_setting/oil_pressure_setting.dart';
import 'package:testappbita/Views/am_2/custom_widget/pressure/pressures_setting/suction_pressure_setting.dart';
import 'package:testappbita/controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Pressures extends StatelessWidget {
  Pressures({super.key});
  final MqttController controller = Get.find<MqttController>();

  void _showPasswordDialog() {
    TextEditingController _passwordController = TextEditingController();
    Get.defaultDialog(
      title: "Enter Password",
      content: Column(
        children: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.number,
                  obscureText: controller.isObscured.value,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isObscured.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        controller.isObscured.value =
                            !controller.isObscured.value;
                      },
                    ),
                  )),
            ),
          ),
          SizedBox(height: Get.height * 0.01),
          ElevatedButton(
            onPressed: () {
              if (_passwordController.text == "1234") {
                controller.isOilPressureVisible.value =
                    !controller.isOilPressureVisible.value;

                Get.back();
              } else {
                Get.snackbar("Error", "Wrong Password!",
                    backgroundColor: Colors.red);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              textStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text("Unlock"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.height * 0.2,
            ),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: ThemeColor().actual,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.air_outlined,
                      size: 30,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Pressures',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => SuctionPressureSetting());
                  },
                  child: Obx(
                    () => Pressurewidget(
                        title: "SUCTION",
                        low: controller.psig1sethigh.value.toString(),
                        setpoint: controller.psig1.value.toString(),
                        getColorLogic: (pressure) => controller.psig1.value <=
                                controller.psig1sethigh.value
                            ? Colors.red
                           : Get.isDarkMode ? Colors.white :Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => DischargePressureSetting());
                  },
                  child: Obx(
                    () => Pressurewidget(
                      title: "DISCHARGE",
                      high: controller.psig2setlow.value.toString(),
                      setpoint: controller.psig2.value.toString(),
                      getColorLogic: (pressure) =>
                          controller.psig2.value <= controller.psig2setlow.value
                              ? Colors.red
                              : Get.isDarkMode ? Colors.white :Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            GestureDetector(
                onLongPress: _showPasswordDialog,
                child: Obx(
                  () => controller.isOilPressureVisible.value
                      ? GestureDetector(
                          onTap: () {
                            Get.to(() => OilPressureSetting());
                          },
                          child: Obx(
                            () => Pressurewidget(
                              title: "OIL",
                              low: controller.psig3sethigh.value.toString(),
                              setpoint: controller.psig3.value.toString(),
                              getColorLogic: (pressure) =>
                                  controller.psig3.value <=
                                          controller.psig3sethigh.value
                                      ? Colors.red
                                     : Get.isDarkMode ? Colors.white :Colors.black,
                            ),
                          ),
                        )
                      :  Icon(Icons.lock, color: Get.isDarkMode ? Colors.white :Colors.black, size: 40),
                )),
          ],
        ),
      ),
    );
  }
}
