class DeviceInfo {
  final String ipAddress;
  final String macAddress;

  DeviceInfo({
    required this.ipAddress,
    required this.macAddress,
  });

  // Factory constructor to create an instance from JSON
  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      ipAddress: json['ip_address'] ?? '',
      macAddress: json['mac_address'] ?? '',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ip_address': ipAddress,
      'mac_address': macAddress,
    };
  }
}

List<DeviceInfo> model = [];
