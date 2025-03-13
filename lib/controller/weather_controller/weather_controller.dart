
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
  fetchWeather(Get.context!);  // Fetch weather on startup

  // Listen for location service changes
  Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
    if (status == ServiceStatus.enabled) {
      fetchWeather(Get.context!);  // Automatically fetch weather when GPS is turned on
    }
  });
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

  // // Get current location
  // Future<Position> _getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     throw "Location services are disabled.";
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       throw "Location permissions are denied.";
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     throw "Location permissions are permanently denied.";
  //   }

  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  // // Fetch weather data from API
  // Future<void> fetchWeather() async {
  //   try {
  //     isLoading.value = true;
  //     Position position = await _getCurrentLocation();
  //     double lat = position.latitude;
  //     double lon = position.longitude;

  //     final url = Uri.parse(
  //         "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey");
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       weatherCondition.value = data["weather"][0]["main"];
  //       temperature.value = data["main"]["temp"].toString();
  //       location.value = data["name"];
  //       subtitle.value =
  //           "Feels like ${data['main']['feels_like']}°C, ${data['weather'][0]['description']}";
  //     } else {
  //       weatherCondition.value = "Error";
  //       location.value = "Failed to fetch";
  //       subtitle.value = "Try again later";
  //     }
  //   } catch (e) {
  //     weatherCondition.value = "Error";
  //     location.value = "Location issue";
  //     subtitle.value = e.toString();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }



Future<Position?> _getCurrentLocation(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    // Show a dialog asking the user to enable location services
    bool? openSettings = await Get.defaultDialog<bool>(
      title: "Location Required",
      content: Text("Location services are disabled. Enable them in settings?"),
      textConfirm: "Open Settings",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(result: true);
        Geolocator.openLocationSettings();
      },
      onCancel: () => Get.back(result: false),
    );

    return null; // Return null if location is still disabled
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null; // Return null if the user still denies permission
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Show a dialog asking the user to manually enable location permission
    bool? openAppSettings = await Get.defaultDialog<bool>(
      title: "Permission Required",
      content: Text("Location permission is permanently denied. Open settings?"),
      textConfirm: "Open Settings",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(result: true);
        Geolocator.openAppSettings();
      },
      onCancel: () => Get.back(result: false),
    );

    return null;
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
Future<void> fetchWeather(BuildContext context) async {
  try {
    isLoading.value = true;
    
    Position? position = await _getCurrentLocation(context);
    if (position == null) {
      location.value = "Location not available";
      subtitle.value = "Enable GPS and try again.";
      return;
    }

    double lat = position.latitude;
    double lon = position.longitude;

    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      weatherCondition.value = data["weather"][0]["main"];
      temperature.value = "${data["main"]["temp"]}°C";
      location.value = data["name"];
      subtitle.value =
          "Feels like ${data['main']['feels_like']}°C, ${data['weather'][0]['description']}";
    } else {
      location.value = "Failed to fetch";
      subtitle.value = "Try again later.";
    }
  } catch (e) {
    location.value = "Network Error";
    subtitle.value = "Check your internet connection.";
  } finally {
    isLoading.value = false;
  }
}


}