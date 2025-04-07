import 'package:get/get.dart';

class CardController extends GetxController {
  var isTapped = false.obs; // State variable to check if the card is tapped

  void onTap() {
    isTapped.value = true;
    Get.defaultDialog(
      title: "Confirm",
      middleText: "Do you want to perform the action?",
      onConfirm: () {
        // Perform the action here
        Get.back(); // Close the dialog
        isTapped.value = false;
      },
      onCancel: () {
        Get.back(); // Close the dialog
        isTapped.value = false;
      },
    );
  }
}
