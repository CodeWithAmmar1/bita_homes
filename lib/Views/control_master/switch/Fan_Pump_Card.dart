
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/switch_controller.dart';
import 'package:testappbita/utils/setting_dialog.dart';

class FanCardView extends StatelessWidget {
  final int index;
  FanCardView({required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SwitchCardController>();

    return SwitchCard(
      index: index,
      title: "Fan Control",
      icon: Icons.settings,
      controller: controller,
    );
  }
}

class PumpCardView extends StatelessWidget {
  final int index;
  PumpCardView({required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SwitchCardController>();

    return SwitchCard(
      index: index,
      title: "Pump Control",
      controller: controller,
    );
  }
}

class SwitchCard extends StatelessWidget {
  final int index;
  final String title;
  final IconData? icon; // Made optional
  final SwitchCardController controller;

  SwitchCard({
    required this.index,
    required this.title,
    this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          controller.toggleSwitch(index);
        },
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.all(16),
            child: Stack(
              children: [
                if (icon != null) // Show icon only if provided
                  Positioned(
                    top: -14,
                    right: -14,
                    child: IconButton(
                      onPressed: () {
                        showTemperatureDialog(context);
                      },
                      icon: Icon(icon),
                    ),
                  ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 10),

                      /// **🛠 FIX: Wrap in `Obx` to update UI when state changes**
                      Obx(() => Text(
                            controller.switchCards[index].actualState ? 'On' : 'Off',
                            style: TextStyle(
                              fontSize: 18,
                              color: controller.switchCards[index].actualState
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          )),

                      Obx(() => Switch(
                            value: controller.switchCards[index].status,
                            onChanged: (value) {
                              controller.toggleSwitch(index);
                            },
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
