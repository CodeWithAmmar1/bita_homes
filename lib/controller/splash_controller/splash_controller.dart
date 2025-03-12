import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/auth/welcome_screen.dart';
import 'package:testappbita/Views/bottom_NavBar/nav_bar.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    Timer(const Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Get.offAll(() => NavBar());
      } else {
        Get.offAll(() => WelcomeScreen());
      }
    });
  }
}