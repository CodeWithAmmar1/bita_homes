import 'package:get/get.dart';

class WaterLevelController extends GetxController {
  var waterLevel = 0.8.obs; // Default 80%

  void increaseLevel() {
    if (waterLevel.value < 1.0) {
      waterLevel.value += 0.1;
    }
  }

  void decreaseLevel() {
    if (waterLevel.value > 0.0) {
      waterLevel.value -= 0.1;
    }
  }
}
