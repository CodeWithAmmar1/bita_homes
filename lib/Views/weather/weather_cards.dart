import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/weather_controller/weather_controller.dart';


// Weather Card UI
class WeatherCard extends StatelessWidget {

   WeatherCard({super.key});
  final WeatherController controller = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          elevation: 3, // Slightly reduced elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // More compact corners
          ),
          child: Container(
            width:  Get.width *
                0.92, 
                height: Get.height*0.06,// Slightly increased width
            padding: EdgeInsets.symmetric(
                horizontal: 12, vertical: 2), // Minimal vertical padding
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
                          fontSize: 12, // Smaller city text
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      // Icon & Temperature (Right)
                      Row(
                        children: [
                          Icon(
                            controller.getWeatherIcon(
                                controller.weatherCondition.value),
                            size: 28, // Even smaller icon
                            color: Colors.white,
                          ),
                          SizedBox(width: 10,), // No extra space
                          Text(
                            controller.temperature.value,
                            style: TextStyle(
                              fontSize: 14, // Slightly smaller temp text
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

  // Loading shimmer effect
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
