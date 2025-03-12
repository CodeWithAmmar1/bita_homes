// import 'package:cloud_firestore/cloud_firestore.dart';

// class DeviceModel {
//   final String? deviceId;
//   final String? deviceIp;
//   final String? deviceMac;
//   final String? deviceName;
//   final Timestamp? lastUpdated;

//   DeviceModel({
//     this.deviceId,
//     this.deviceIp,
//     this.deviceMac,
//     this.deviceName,
//     this.lastUpdated,
//   });

//   DeviceModel copyWith({
//     String? deviceId,
//     String? deviceIp,
//     String? deviceMac,
//     String? deviceName,
//     Timestamp? lastUpdated,
//   }) {
//     return DeviceModel(
//       deviceId: deviceId ?? this.deviceId,
//       deviceIp: deviceIp ?? this.deviceIp,
//       deviceMac: deviceMac ?? this.deviceMac,
//       deviceName: deviceName ?? this.deviceName,
//       lastUpdated: lastUpdated ?? this.lastUpdated,
//     );
//   }

//   // Convert the object to JSON for Firestore
//   Map<String, dynamic> toJson() {
//     return {
//       'deviceId': deviceId,
//       'deviceIp': deviceIp,
//       'deviceMac': deviceMac,
//       'deviceName': deviceName,
//       'lastUpdated': lastUpdated,
//     };
//   }

//   // Create an object from Firestore JSON
//   factory DeviceModel.fromJson(Map<String, dynamic> json) {
//     return DeviceModel(
//       deviceId: json['deviceId'] as String?,
//       deviceIp: json['deviceIp'] as String?,
//       deviceMac: json['deviceMac'] as String?,
//       deviceName: json['deviceName'] as String?,
//       lastUpdated: json['lastUpdated'] as Timestamp?,
//     );
//   }
// }
class DeviceModel {
  final String? deviceId;
  final String? deviceIp;
  final String? deviceMac;
  final String? deviceName;
  final DateTime? lastUpdated;

  DeviceModel({
    this.deviceId,
    this.deviceIp,
    this.deviceMac,
    this.deviceName,
    this.lastUpdated,
  });

  DeviceModel copyWith({
    String? deviceId,
    String? deviceIp,
    String? deviceMac,
    String? deviceName,
    DateTime? lastUpdated,
  }) {
    return DeviceModel(
      deviceId: deviceId ?? this.deviceId,
      deviceIp: deviceIp ?? this.deviceIp,
      deviceMac: deviceMac ?? this.deviceMac,
      deviceName: deviceName ?? this.deviceName,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceIp': deviceIp,
      'deviceMac': deviceMac,
      'deviceName': deviceName,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      deviceId: json['deviceId'] as String?,
      deviceIp: json['deviceIp'] as String?,
      deviceMac: json['deviceMac'] as String?,
      deviceName: json['deviceName'] as String?,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }
}
