import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/setting_screen/settings_screen.dart';
import 'package:testappbita/Views/zone_master/Device/device.dart';
import 'package:testappbita/controller/nav_bar_controller/nav_bar_controller.dart';
import 'package:testappbita/utils/theme/theme_controller.dart';

class NavBar extends StatelessWidget {
  final NavBarController controller = Get.put(NavBarController());
  final ThemeController themeController = Get.find<ThemeController>();

  final List<Widget> screens = [
    DevicesPage(),
    DevicesScreen(),
    SettingsScreen(),
  ];

  NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Get.isDarkMode;

    return Obx(() {
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: screens,
        ),
        bottomNavigationBar: Container(
          height: 60, // Reduce height of the navbar
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: Obx(() {
            bool isDarkMode = themeController.isDarkMode.value;
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: isDark ? Colors.grey[900] : Colors.white,
              selectedItemColor:Color(0xFF24C48E),
              unselectedItemColor: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
              selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 10),
              iconSize: 30,// Decrease icon size
              onTap: (index) => controller.updateIndex(index),
              currentIndex: controller.currentIndex.value,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2), // Reduce spacing
                    child: Icon(Icons.home_rounded),
                  ),
                  label: "home".tr,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Icon(Icons.devices_rounded),
                  ),
                  label: "device".tr,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Icon(Icons.person),
                  ),
                  label: "me".tr,
                ),
              ],
            );
          }),
        ),
      );
    });
  }
}


class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Devices'),
      ),
      body: Center(
        child: Text('Devices Screen'),
      ),
    );
  }
}