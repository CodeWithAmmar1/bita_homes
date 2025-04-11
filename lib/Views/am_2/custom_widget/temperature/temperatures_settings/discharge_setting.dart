import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:testappbita/controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DischargeSetting extends StatelessWidget {
  DischargeSetting({
    super.key,
  });
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Get.isDarkMode ? ThemeColor().mode2 :ThemeColor().mode1,
        appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text("Discharge Setting",style: TextStyle(color:  Get.isDarkMode ? ThemeColor().mode2 :ThemeColor().mode1,),),
      
    
        automaticallyImplyLeading: false,
       
      ),
      body: Padding(
        padding: EdgeInsets.all(Get.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            
            SizedBox(height: Get.height * 0.04),
                Expanded(
              child: SleekCircularSlider(
                appearance: CircularSliderAppearance(
                  size: Get.width * 0.75,
                  startAngle: 150,
                  angleRange: 240,
                  customWidths: CustomSliderWidths(
                    progressBarWidth: Get.width * 0.015,
                    trackWidth: Get.width * 0.015,
                  ),
                  customColors: CustomSliderColors(
                     trackColor: Colors.grey[500],
                    progressBarColors: [
                      Color(0xFF24C48E),
                        Color(0xFF24C456)
                    ],
                    dotColor: Colors.white,
                  ),
                ),
                min: 0,
                max: 100,
                initialValue: _mqttController.temp4.value.toDouble(),
                onChange: null,
                innerWidget: (double value) => Center(
                  child: Center(
                    child: Container(
                      width: Get.width*0.59,
                       height: Get.height*0.59,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:  Get.isDarkMode ? ThemeColor().mode2Sec :ThemeColor().mode1Sec ,
                        // borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                      BoxShadow(
                        color: Get.isDarkMode ? ThemeColor().actual.withValues(alpha: 0.8) : Colors.black26,
                        blurRadius: 20,
                        spreadRadius: 8,
                      ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "${_mqttController.temp4.value.toDouble().toStringAsFixed(0)}°C",
                          style: TextStyle( fontFamily: 'DS-Digital',
                            fontSize: Get.width * 0.2,
                              fontWeight: FontWeight.bold,
                            color:Get.isDarkMode ? Colors.white :Colors.black,
                            
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.03),
            _buildSlider2("High Temperature", Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider2(String title, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color:Get.isDarkMode ? Colors.white :Colors.black,
                  letterSpacing: 1.1,
                ),
              ),
              Obx(
                () => Text(
                  "${_mqttController.temp4setlow.value.toDouble().toStringAsFixed(0)}°C",
                  style: TextStyle(
                    fontSize: Get.width * 0.04,
                    fontWeight: FontWeight.bold,
                   color:Get.isDarkMode ? Colors.white :Colors.black,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(Get.context!).copyWith(
            thumbColor: color,
            activeTrackColor: color,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
            overlayColor: color.withValues(alpha: 0.3),
          ),
          child: Obx(
            () => Slider(
              value: _mqttController.temp4setlow.value.toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (double value) {
                _mqttController.updateDischargeHigh(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
