import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherController extends GetxController {
  var weatherCondition = "Loading...".obs;
  var temperature = "--".obs;
  var location = "Fetching...".obs;
  var subtitle = "".obs;
  var isLoading = true.obs;

  final String apiKey = dotenv.env['API_KEY'] ?? "";

  @override
  void onInit() {
    super.onInit();
    fetchWeather();
  }

  // Function to get weather icon based on condition
  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case "clear":
        return Icons.wb_sunny;
      case "clouds":
        return Icons.cloud;
      case "rain":
        return Icons.grain;
      case "thunderstorm":
        return Icons.flash_on;
      case "snow":
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }

  // Get current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw "Location services are disabled.";
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw "Location permissions are denied.";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw "Location permissions are permanently denied.";
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Fetch weather data from API
  Future<void> fetchWeather() async {
    try {
      isLoading.value = true;
      Position position = await _getCurrentLocation();
      double lat = position.latitude;
      double lon = position.longitude;

      final url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        weatherCondition.value = data["weather"][0]["main"];
        temperature.value = data["main"]["temp"].toString();
        location.value = data["name"];
        subtitle.value =
            "Feels like ${data['main']['feels_like']}°C, ${data['weather'][0]['description']}";
      } else {
        weatherCondition.value = "Error";
        location.value = "Failed to fetch";
        subtitle.value = "Try again later";
      }
    } catch (e) {
      weatherCondition.value = "Error";
      location.value = "Location issue";
      subtitle.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

// Weather Card UI
class WeatherCard extends StatelessWidget {
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
                            "${controller.temperature.value}°C",
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
