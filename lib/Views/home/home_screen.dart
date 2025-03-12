// import 'package:bita_homes/Views/qr_code/qr_code_scanner_page.dart';
// import 'package:bita_homes/Views/weather/weather_cards.dart';
// import 'package:bita_homes/Views/zone_master/Device/device.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// // class _HomePageState extends State<HomePage> {
// //   // Sample dynamic data for cards
// //   List<Map<String, dynamic>> devices = [
// //     {
// //       'title': 'Weather',
// //       'status': true,
// //       'icon': Icons.lightbulb,
// //       'logo': 'assets/images/icon.png',
// //       'page': LightBulbPage()
// //     },
// //     {
// //       'title': 'WiFi Router',
// //       'status': false,
// //       'icon': Icons.wifi,
// //       'logo': 'assets/images/icon.png',
// //       'page': WiFiRouterPage()
// //     },
// //     {
// //       'title': 'TV',
// //       'status': true,
// //       'icon': Icons.tv,
// //       'logo': 'assets/images/icon.png',
// //       'page': TVPage()
// //     },
// //     {
// //       'title': 'Motorr',
// //       'status': false,
// //       'icon': Icons.router,
// //       'logo': 'assets/images/icon.png',
// //       'page': MotorPage()
// //     },
// //   ];

// //     final isDarkMode = Get.isDarkMode;
// //   @override
// //   Widget build(BuildContext context) {

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           'Home Page',
// //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkMode? Colors.white:Colors.black)
// //         ),

// //         backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
// //         // backgroundColor: isDarkMode ? Colors.black87 : Color.fromARGB(255, 195, 255, 235),
// //         iconTheme:
// //             IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
// //         actions: [
// //           CustomIconButton(icon: Icons.notifications, onPressed: () {}),
// //           SizedBox(width: 10),
// //           CustomIconButton(
// //             icon: Icons.add,
// //             onPressed: () => Get.to(() => QRCodeScanner()),
// //           ),
// //           SizedBox(width: 15), // Adds space from the right
// //         ],
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: isDarkMode
// //                 ? [Colors.black87, Colors.black54]
// //                 : [Colors.white, Colors.white],
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //           ),
// //         ),
// //         child: Column(
// //           children: [
// //             WeatherCard(),
// //             Padding(
// //               padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
// //               child: SingleChildScrollView(
// //                 child: GridView.builder(
// //                   shrinkWrap: true,
// //                   physics: NeverScrollableScrollPhysics(),
// //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                     crossAxisCount: 2,
// //                     crossAxisSpacing: 6,
// //                     mainAxisSpacing: 10,
// //                     childAspectRatio: 1.2,
// //                   ),
// //                   itemCount: devices.length,
// //                   itemBuilder: (context, index) {
// //                     return GestureDetector(
// //                       onTap: () {
// //                         Get.to(() => devices[index]['page']);
// //                       },
// //                       child: Card(
// //                         elevation: 0,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         color: isDarkMode ? Colors.grey[900] : Colors.white,
// //                         child: Container(
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(12),
// //                             color: devices[index]['status']
// //                                 ? (isDarkMode
// //                                     ? Colors.green[100]
// //                                     : Colors.green[100])
// //                                 : (isDarkMode
// //                                     ? Colors.grey[400]
// //                                     : Colors.white),
// //                             boxShadow: [
// //                               BoxShadow(
// //                                 color: Colors.black.withOpacity(0.3),
// //                                 blurRadius: 8,
// //                                 spreadRadius: 3,
// //                                 offset: Offset(2, 4),
// //                               ),
// //                             ],
// //                           ),
// //                           child: Padding(
// //                             padding: const EdgeInsets.all(12.0),
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Row(
// //                                   mainAxisAlignment:
// //                                       MainAxisAlignment.spaceBetween,
// //                                   children: [
// //                                     Image.asset(
// //                                       devices[index]['logo'],
// //                                       width: 40,
// //                                       height: 40,
// //                                     ),
// //                                     Container(
// //                                       decoration: BoxDecoration(
// //                                         shape: BoxShape.circle,
// //                                         color: devices[index]['status']
// //                                             ? Colors.green.withOpacity(0.2)
// //                                             : Colors.transparent,
// //                                       ),
// //                                       child: IconButton(
// //                                         icon: Icon(
// //                                           Icons.power_settings_new,
// //                                           size: 22,
// //                                           color: devices[index]['status']
// //                                               ? Colors.green
// //                                               : (isDarkMode
// //                                                   ? Colors.grey[600]
// //                                                   : Colors.grey),
// //                                         ),
// //                                         onPressed: () {
// //                                           setState(() {
// //                                             devices[index]['status'] =
// //                                                 !devices[index]['status'];
// //                                           });
// //                                         },
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 SizedBox(height: 5),
// //                                 Expanded(
// //                                   child: Column(
// //                                     mainAxisAlignment: MainAxisAlignment.center,
// //                                     crossAxisAlignment:
// //                                         CrossAxisAlignment.start,
// //                                     children: [
// //                                       Text(
// //                                         devices[index]['title'],
// //                                         style: TextStyle(
// //                                           fontSize: 16,
// //                                           fontWeight: FontWeight.bold,
// //                                           color: isDarkMode
// //                                               ? Colors.white
// //                                               : Colors.black87,
// //                                         ),
// //                                       ),
// //                                       Text(
// //                                         devices[index]['status'] ? 'ON' : 'OFF',
// //                                         style: TextStyle(
// //                                           fontSize: 14,
// //                                           color: isDarkMode
// //                                               ? Colors.grey[400]
// //                                               : Colors.grey[700],
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// class _HomePageState extends State<HomePage> {
//   List<Map<String, dynamic>> devices = [
//     {
//       'title': 'Zone Master',
//       'status': true,
//       'icon': Icons.lightbulb,
//       'logo': 'assets/images/icon.png',
//       'page': () => DevicesPage()

//     },
//     {
//       'title': 'Aqua Master',
//       'status': false,
//       'icon': Icons.wifi,
//       'logo': 'assets/images/icon.png',
//       'page': () => WiFiRouterPage()
//     },
//     {
//       'title': 'Contol Master',
//       'status': true,
//       'icon': Icons.tv,
//       'logo': 'assets/images/icon.png',
//       'page': TVPage()
//     },
//     {
//       'title': 'Motor',
//       'status': false,
//       'icon': Icons.router,
//       'logo': 'assets/images/icon.png',
//       'page': MotorPage()
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Home Page',
//           style: TextStyle(
//             fontSize: 20, 
//             fontWeight: FontWeight.bold, 
//             color: isDarkMode ? Colors.white : Colors.black,
//           ),
//         ),
//         backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
//         iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
//         actions: [
//           CustomIconButton(icon: Icons.notifications, onPressed: () {}),
//           SizedBox(width: 10),
//           CustomIconButton(
//             icon: Icons.add,
//             onPressed: () => Get.to(() => QRCodeScanner()),
//           ),
//           SizedBox(width: 15),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isDarkMode
//                 ? [Colors.black87, Colors.black54]
//                 : [Colors.white, Colors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           children: [
//             WeatherCard(),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               child: SingleChildScrollView(
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 6,
//                     mainAxisSpacing: 10,
//                     childAspectRatio: 1.2,
//                   ),
//                   itemCount: devices.length,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () => Get.to(devices[index]['page']),
//                       child:
//                        Card(
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         color: isDarkMode ? Colors.grey[900] : Colors.white,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: devices[index]['status']
//                                 ? (isDarkMode ? Colors.green[800] : Colors.green[100])
//                                 : (isDarkMode ? Colors.grey[700] : Colors.white),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 blurRadius: 6,
//                                 spreadRadius: 2,
//                                 offset: Offset(2, 3),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Image.asset(
//                                       devices[index]['logo'],
//                                       width: 40,
//                                       height: 40,
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: devices[index]['status']
//                                             ? Colors.green.withOpacity(0.2)
//                                             : Colors.transparent,
//                                       ),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.power_settings_new,
//                                           size: 22,
//                                           color: devices[index]['status']
//                                               ? Colors.green
//                                               : (isDarkMode ? Colors.grey[400] : Colors.grey),
//                                         ),
//                                         onPressed: () {
//                                           setState(() {
//                                             devices[index]['status'] = !devices[index]['status'];
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 5),
//                                 Expanded(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         devices[index]['title'],
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           color: isDarkMode ? Colors.white : Colors.black87,
//                                         ),
//                                       ),
//                                       Text(
//                                         devices[index]['status'] ? 'ON' : 'OFF',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class MotorPage {}

// class TVPage {}

// class WiFiRouterPage {}

// class LightBulbPage {}

// class CustomIconButton extends StatefulWidget {
//   final IconData icon;
//   final VoidCallback onPressed;

//   const CustomIconButton(
//       {Key? key, required this.icon, required this.onPressed})
//       : super(key: key);

//   @override
//   _CustomIconButtonState createState() => _CustomIconButtonState();
// }

// class _CustomIconButtonState extends State<CustomIconButton> {
//   bool isPressed = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) {
//         setState(() {
//           isPressed = true;
//         });
//       },
//       onTapUp: (_) {
//         Future.delayed(Duration(milliseconds: 200), () {
//           setState(() {
//             isPressed = false;
//           });
//         });
//         widget.onPressed();
//       },
//       onTapCancel: () {
//         setState(() {
//           isPressed = false;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: isPressed
//               ? Colors.grey.withOpacity(0.1)
//               : Colors.grey.withOpacity(0.1), // Background effect
//         ),
//         child: Icon(widget.icon,
//             color: isPressed
//                 ? Color(0xFF24C48E)
//                 : Color(0xFF24C48E)), // Change icon color
//       ),
//     );
//   }
// }
