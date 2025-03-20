import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DeviceCard extends StatefulWidget {
  final String title;
  final String macAddress;
  final String deviceId;
  final String ipAddress;
  final void Function() onSetting;
  final void Function() onDelete;

  const DeviceCard({
    super.key,
    required this.title,
    required this.macAddress,
    required this.deviceId,
    required this.ipAddress,
    required this.onSetting,
    required this.onDelete,
  });

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  bool isSheetOpen = false;

  void _toggleSheet() {
    setState(() {
      isSheetOpen = !isSheetOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color(0xFF24C48E)
                    ),
                    child: IconButton(
                      icon: Center(
                        child: Icon(
                          Icons.edit,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: widget.onSetting,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color(0xFF24C48E),
                    ),
                    child: IconButton(
                      icon: Center(
                        child: Icon(
                          Icons.delete_forever,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: widget.onDelete,
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleSheet,
                    child: Icon(
                      isSheetOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isSheetOpen ? 100 : 0,
          width: isSheetOpen ? Get.width*0.9:0,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color:  Color(0xFF24C48E).withValues(alpha: 0.2),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MAC: ${widget.macAddress}',
                    style: TextStyle(fontSize: 12)),
                SizedBox(height: 5),
                Text('Device ID: ${widget.deviceId}',
                    style: TextStyle(fontSize: 12)),
                SizedBox(height: 5),
                Text('IP Address: ${widget.ipAddress}',
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}