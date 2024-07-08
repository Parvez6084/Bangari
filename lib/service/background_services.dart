
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import '../data/firebaseDB_model.dart';
import '../data/location_model.dart';
import 'database.dart';




void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke("stopService");
}



Future<void> backgroundServiceRegister() async {

  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      autoStartOnBoot: false ,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp();

  StreamSubscription<Position>? positionStream;
  late LocationSettings locationSettings;

  DatabaseReference fireData = FirebaseDatabase.instance.ref("/FieldForce/AssignTicket");
  fireData.child('L3T2167').onValue.listen((DatabaseEvent event) {
    DataSnapshot dataSnapshot = event.snapshot;
    Map<dynamic, dynamic> values = dataSnapshot.value as Map;
    var firebaseDB = FirebaseDBModel.fromJson(values);
    if (firebaseDB.isTicketAssign == false) {
      positionStream?.cancel();
    }
  });

  if (Platform.isAndroid) {
    locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
      forceLocationManager: true,
      intervalDuration: const Duration(seconds: 0),
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText: "Location Tracking",
        notificationTitle: "Running in Background",
        notificationChannelName: "Location Tracking",
        enableWakeLock: true,
        setOngoing: true,
      ),
    );
  } else if (Platform.isIOS) {
    locationSettings = AppleSettings(
      accuracy: LocationAccuracy.high,
      activityType: ActivityType.fitness,
      distanceFilter: 100,
      pauseLocationUpdatesAutomatically: true,
      showBackgroundLocationIndicator: true,
      allowBackgroundLocationUpdates: true,
    );
  }

  positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) async{
    if (position != null) {
      final location = Location(latitude: position.latitude, longitude: position.longitude);
      await DatabaseHelper.instance.insertLocation(location);
    }
  });

  service.on('stopService').listen((event) async {
    positionStream?.cancel();
    await service.stopSelf();
  });

}
