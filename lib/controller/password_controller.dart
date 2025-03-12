import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PasswordController extends GetxController {
  var isPasswordVisible = false.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}

// Controller for handling text fields and button state
class TextFieldController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isButtonEnabled = false.obs;

  void checkFields() {
    isButtonEnabled.value =
        emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }
}