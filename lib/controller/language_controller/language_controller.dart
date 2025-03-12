import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  RxBool isEnglish = true.obs;

  @override
  void onInit() {
    loadSavedLanguage();
    super.onInit();
  }

  void toggleLanguage() async {
    isEnglish.value = !isEnglish.value;
    Get.updateLocale(isEnglish.value ? Locale('en', 'US') : Locale('ar'));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isEnglish', isEnglish.value);
  }

  void loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedLanguage = prefs.getBool('isEnglish');
    if (savedLanguage != null) {
      isEnglish.value = savedLanguage;
      Get.updateLocale(savedLanguage ? Locale('en', 'US') : Locale('ar'));
    }
  }
}
