import 'package:device_apps/device_apps.dart';

class ApplicationModel{

  final Application app;
  final int usageTime;
  final int timer;
  final bool lockStatus;

  ApplicationModel({
    required this.app,
    this.usageTime = 0,
    this.timer = 0,
    this.lockStatus = false,
  });


}