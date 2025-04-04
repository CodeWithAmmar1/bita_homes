import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/weather_controller/weather_controller.dart';


class WeatherCard extends StatelessWidget {

   WeatherCard({super.key});
  final WeatherController controller = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          elevation: 3, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width:  Get.width *
                0.92, 
                height: Get.height*0.06,
            padding: EdgeInsets.symmetric(
                horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [Colors.lightBlue.shade200, Colors.lightBlue.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: controller.isLoading.value
                ? _buildLoadingShimmer()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // City Name (Left)
                      Text(
                        controller.location.value,
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            controller.getWeatherIcon(
                                controller.weatherCondition.value),
                            size: 28, 
                            color: Colors.white,
                          ),
                          SizedBox(width: 10,), 
                          Text(
                            controller.temperature.value,
                            style: TextStyle(
                              fontSize: 14, 
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ));
  }

  Widget _buildLoadingShimmer() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: Colors.white),
       SizedBox(width: 10,),
        Text("Fetching weather...",
            style: TextStyle(fontSize: 10, color: Colors.white)),
      ],
    );
  }
}
