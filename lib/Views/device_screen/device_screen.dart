import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/device_screen/custom_widget/device_card.dart';
import 'package:testappbita/services/firebase_service.dart';
import 'package:testappbita/model/user_device_model.dart';
import 'package:testappbita/utils/theme/theme.dart';


class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  List<DeviceModel> allDeviceData = [];

  void getTaskListner() {
    SharedPreferencesService().listenToUserDevices().listen((allTask) {
      debugPrint('Received Data: $allTask');
      setState(() {
        allDeviceData = allTask;
      });
    }, onError: (error) {
      debugPrint('Error in Listener: $error');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaskListner();
  }

  void _showEditNameDialog(BuildContext context, DeviceModel device) {
    final TextEditingController _nameController =
        TextEditingController(text: device.deviceName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeColor().dialogBox,
          title: Text('Edit Device Name'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  await SharedPreferencesService().updateDeviceName(
                    deviceId: device.deviceId ?? "",
                    newName: _nameController.text,
                  );
                  Navigator.of(context).pop();
                  getTaskListner();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("device_list".tr, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),),
           
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: allDeviceData.length,
          itemBuilder: (context, index) {
            final device = allDeviceData[index];

            return DeviceCard(
                title: '${allDeviceData[index].deviceName}',
                macAddress: '${allDeviceData[index].deviceMac}',
                deviceId: '${allDeviceData[index].deviceId}',
                ipAddress: '${allDeviceData[index].deviceIp}',
                onSetting: () {
                  _showEditNameDialog(context, device);
                },
                onDelete: () {
                  SharedPreferencesService().deleteDeviceData(
                      deviceId: allDeviceData[index].deviceId ?? "");
                });
          },
        ),
      ),
    );
  }
}