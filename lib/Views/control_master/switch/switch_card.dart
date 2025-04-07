
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/switch_controller.dart';
import 'package:testappbita/utils/setting_dialog.dart';

class SwitchCardView extends StatelessWidget {
  final int index;
  final IconData? icon;
  final Function(bool value) onToggle;

  SwitchCardView({required this.index, required this.icon, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    // Get the controller
    final controller = Get.find<SwitchCardController>();

    return GestureDetector(
      onTap: () {
        // Toggle the switch status when the card is tapped
        controller.toggleSwitch(index);
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
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
              Positioned(
                top: -14,
                right: -14,
                child: IconButton(
                  onPressed: () {
                    showTemperatureDialog(context); // Call the function to show dialog
                  },
                  icon: Icon(icon),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          controller.switchCards[index].title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(() => Text(
                          controller.switchCards[index].status ? 'On' : 'Off',
                          style: TextStyle(
                            fontSize: 18,
                            color: controller.switchCards[index].status
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),),
                        Obx(() => Switch(
                          value: controller.switchCards[index].status,
                          onChanged: (value) {
                            onToggle(value);
                          },
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.red,
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}