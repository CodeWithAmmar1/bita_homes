import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testappbita/Views/bottom_NavBar/nav_bar.dart';
import 'package:testappbita/model/user_device_model.dart';
import 'package:testappbita/services/firebase_service.dart';
import 'package:testappbita/utils/button/button.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class QRCodeScanner extends StatefulWidget {
  QRCodeScanner();

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner>
    with SingleTickerProviderStateMixin {
  bool isScanning = true;
  MobileScannerController cameraController = MobileScannerController();
  List<Map<String, String>> scannedConnections = [];
  int id = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isConnectedToDevice = false;
  bool isLoading = false;
  bool isDialogOpen = true;

  final apiUrl = Uri.parse('http://192.168.4.1/wifi_param_by_app');
  bool showIndicator = true; // Indicator initially dikhayega

  @override
  void initState() {
    super.initState();
    _requestPermissions().then((_) {
      setState(() {
        cameraController =
            MobileScannerController(); // Initialize after permissions
      });
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Properly dispose the animation controller
    cameraController.dispose(); // Dispose the camera controller
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.location.request();
  }

  Future<void> sendWifiCredentials(
      String ssid, String password, String dssid, String dpassword) async {
    var response = await http.post(apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"ssid": ssid, "password": password}));
    print(
        "checkingissue 2063| response body= ${response.body} response code = ${response.statusCode}");
    if (response.statusCode == 200) {
      Get.snackbar('Response', response.body);

      WiFiForIoTPlugin.forceWifiUsage(false);

      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        log('ESP32 successfully configured.');
        await _showdevicenameDialog(dssid, dpassword);
      } else {
        Get.snackbar('Error', response.body);

        log('Error: ${response.body}');
      }
    } else {
      log('Failed with status code: ${response.statusCode} ISUEEEEEEEEEE______-');
    }
  }

  Future<void> diconnectwifi() async {
    final disconnectedd = await WiFiForIoTPlugin.disconnect();
    if (disconnectedd) {
      log("Disconnected");
    } else {
      log("Not Disconnected");
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty && isScanning) {
      final String? code = capture.barcodes.first.rawValue;
      if (code != null) {
        setState(() {
          isScanning = false;
          cameraController.stop();
          isDialogOpen = false;
        });

        _parseQRCode(code);
      }
    }
  }

  Future<void> _parseQRCode(String code) async {
    print("Scanned QR Code: $code");

    final wifiRegex = RegExp(
      r'WIFI:T:[^;]*;S:(?<ssid>[^;]*);P:(?<password>[^;]*);(?:H:(?:true|false|);)?',
      caseSensitive: false,
    );

    final wifiMatch = wifiRegex.firstMatch(code);

    if (wifiMatch != null) {
      final ssid = wifiMatch.namedGroup('ssid');
      final password = wifiMatch.namedGroup('password');

      if (ssid?.isNotEmpty == true && password?.isNotEmpty == true) {
        _connectToWiFi(ssid!, password!);
      } else {
        print("SSID or Password is null or empty.");
      }
    } else {
      print("No match for Wi-Fi QR code.");
    }
  }

  Future<void> _connectToWiFi(String ssid, String password) async {
    bool isConnected = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: NetworkSecurity.WPA,
      isHidden: true,
      joinOnce: true,
      withInternet: false,
    );

    if (isConnectedToDevice == false) {
      if (isConnected) {
        isConnectedToDevice = true;
        print("Connected to ${ssid}");

        await _showWiFiDialog(ssid, password);

        print("Connected to ${ssid}");
        await WiFiForIoTPlugin.forceWifiUsage(true);
      } else {
        _showErrorDialog(context);

        print("Failed to connect to $ssid");
      }
    }
  }

  void _showErrorDialog(BuildContext context) async {
    setState(() {
      isScanning = false; // Hide scanner and show indicator
    });

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Error',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'There was an error scanning the code. Please try again.',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isScanning = true; // Resume scanning after dialog
                });
              },
              child: Text('OK', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showWiFiDialog(String ssid, String password) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.withOpacity(0.3), // Dark background
          title: Text(
            'Connect Damper to Wi-Fi',
            style: TextStyle(color: Colors.white), // White text
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.green), // Green focus
                    ),
                    labelText: 'Connection Name',
                    labelStyle:
                        TextStyle(color: Colors.white), // White label text
                  ),
                  style: TextStyle(color: Colors.white), // White input text
                  cursorColor: Colors.white,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white), // White input text
                  cursorColor: Colors.white,
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Button(
              onTap: () {
                final ssidd = nameController.text;
                final pass = passwordController.text;

                if (ssidd.isNotEmpty) {
                  sendWifiCredentials(ssidd, pass, ssid, password);
                }
                Navigator.of(context).pop();
              },
              buttonText: 'Send',
            ),
          ],
        );
      },
    );
  }

  Future<void> _showdevicenameDialog(String ssid, String password) async {
    // final isDarkMode = Get.isDarkMode; // ✅ Dark mode check

    TextEditingController nameController = TextEditingController();
    bool isDialogLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.grey.withOpacity(0.3),
              title: Text(
                'Enter Your Device Name',
                style: TextStyle(color: Colors.white // ✅ Dynamic text color
                    ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.tealAccent,
                          ),
                        ),
                        labelText: 'Device Name',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      cursorColor: Colors.tealAccent,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isDialogLoading = true;
                    });

                    final ssidd = nameController.text;
                    final ip = "000.000.000.000";
                    final mac = "00:00:00:00:00:00";
                    String deviceid = ssid;

                    debugPrint("$ip $mac $ssidd $deviceid");

                    await SharedPreferencesService().sendDeviceData(
                      data: DeviceModel(
                        deviceId: deviceid,
                        deviceIp: ip,
                        deviceMac: mac,
                        deviceName: ssidd,
                      ),
                    );

                    final isDisconnect = await WiFiForIoTPlugin.disconnect();
                    log("$isDisconnect Disconnected");

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('deviceId', deviceid);
                    log("${prefs.getString('deviceId')} Device Saved");

                    setState(() {
                      isDialogLoading = false;
                    });

                    Get.offAll(() => NavBar());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isDialogLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Send",
                          style: TextStyle(
                              color: Colors
                                  .black), // Adjusted text color for dark mode
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          ClipRRect(
            child: isScanning
                ? MobileScanner(
                    controller: cameraController,
                    onDetect: _onDetect,
                  )
                : Center(
                    child: isDialogOpen ? SizedBox.shrink() : SizedBox(),
                  ),
          ),
          if (isScanning)
            Positioned(
              top: 18,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    margin: EdgeInsets.only(
                        top: _animation.value * (Get.height * 0.8 - 10)),
                    height: 5,
                    width: double.infinity,
                    color: Colors.redAccent.withValues(alpha: 0.8),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
