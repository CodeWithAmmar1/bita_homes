import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/language_controller/language_controller.dart';

class LanguageToggle extends StatelessWidget {
  final LanguageController langController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.isDarkMode; // ✅ Check theme mode

    return Obx(() => Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isDarkMode ? Colors.grey[800] : Colors.white, // ✅ Adjust for theme
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleButton('English', langController.isEnglish.value, true, isDarkMode),
              _buildToggleButton('عربي', !langController.isEnglish.value, false, isDarkMode),
            ],
          ),
        ));
  }

  Widget _buildToggleButton(String text, bool isActive, bool isLeft, bool isDarkMode) {
    return GestureDetector(
      onTap: langController.toggleLanguage,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isActive 
              ? (isDarkMode ? Colors.blueGrey : Colors.blue) // ✅ Adjust active color
              : (isDarkMode ? Colors.black54 : Colors.white), // ✅ Adjust inactive color
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
