import 'package:get/get.dart';
import 'package:testappbita/services/sharedpreference.dart';

class OpacityController extends GetxController {
  RxDouble dashboardOpacity = 0.5.obs;
  RxDouble deviceOpacity = 0.5.obs;

  @override
  void onInit() {
    super.onInit();
    loadOpacity();
  }

  Future<void> loadOpacity() async {
    dashboardOpacity.value =
        await Sharedpreference14().loadOpacity('dashboard');
    deviceOpacity.value = await Sharedpreference14().loadOpacity('device');

    dashboardOpacity.refresh();

    deviceOpacity.refresh();
  }
}
