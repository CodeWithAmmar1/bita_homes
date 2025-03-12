import 'package:shared_preferences/shared_preferences.dart';

class Sharedpreference14 {
  Future<void> saveOpacity(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future<double> loadOpacity(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 0.5;
  }

  // Future<void> saveOpacityDevice(double value) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setDouble('opacity', value);
  // }

  // Future<double> loadOpacityDevice() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getDouble('opacity') ?? 0.5;
  // }
}
