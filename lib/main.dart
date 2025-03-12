
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/auth/welcome_screen.dart';

import 'package:testappbita/Views/bottom_NavBar/nav_bar.dart';
import 'package:testappbita/Views/splash/splash_Screen.dart';
import 'package:testappbita/firebase_options.dart';
import 'package:testappbita/services/localization/localization.dart';
import 'package:testappbita/utils/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Get.put(ThemeController());
  await dotenv.load(); // Load the .env file
 
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: MyTranslations(),
          locale: Locale('en', 'US'),
          fallbackLocale: Locale('en', 'US'),
          theme: ThemeData(
            fontFamily: 'Roboto-Regular', // Set global font
            brightness: Brightness.light,
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontSize: 14),
              bodyMedium: TextStyle(fontSize: 12),
              titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          darkTheme: ThemeData(
            fontFamily: 'Roboto-Regular', // Ensure dark mode uses the same font
            brightness: Brightness.dark,
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontSize: 14, color: Colors.white),
              bodyMedium: TextStyle(fontSize: 12, color: Colors.white70),
              titleLarge: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          themeMode: themeController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          home:Splash()
        ));
  }
}
