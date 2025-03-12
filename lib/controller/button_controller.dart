import 'package:get/get.dart';
import 'package:testappbita/model/button_model.dart';

class ButtonController extends GetxController {
  var buttons = <ButtonModel>[
    ButtonModel(text: "LOGIN", id: 1, route: ''),
    ButtonModel(text: "REGISTER", id: 2, route: ''),
  ].obs;

  void showSnackbar(String text) {
    Get.snackbar("Button Clicked", "$text Pressed!",
        snackPosition: SnackPosition.TOP);
  }
}