// /*
// import 'dart:async';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:geolocator/geolocator.dart';
//
// import '../data/firebaseDB_model.dart';
//
// class LocationService {
//   StreamSubscription<Position>? positionStream;
//   late LocationSettings locationSettings;
//
//   LocationService(){
//     initializeLocationSettings();
//     firebaseListener();
// //   }
// //
// //   void initializeLocationSettings() async{
// //     if (defaultTargetPlatform == TargetPlatform.android) {
// //       locationSettings = AndroidSettings(
// //         accuracy: LocationAccuracy.high,
// //         distanceFilter: 2,
// //         forceLocationManager: true,
// //         intervalDuration: const Duration(seconds: 0),
// //         foregroundNotificationConfig: const ForegroundNotificationConfig(
// //           notificationText: "Location Tracking",
// //           notificationTitle: "Running in Background",
// //           notificationChannelName: "Location Tracking",
// //           enableWakeLock: true,
// //           setOngoing: true,
// //         ),
// //       );
// //     } else if (defaultTargetPlatform == TargetPlatform.iOS) {
// //       locationSettings = AppleSettings(
// //         accuracy: LocationAccuracy.high,
// //         activityType: ActivityType.fitness,
// //         distanceFilter: 100,
// //         pauseLocationUpdatesAutomatically: true,
// //         showBackgroundLocationIndicator: true,
// //         allowBackgroundLocationUpdates: true,
// //       );
// //     }
// //
// //   }
// //
// //   void firebaseListener() {
// //     DatabaseReference fireData = FirebaseDatabase.instance.ref("/FieldForce/AssignTicket");
// //     fireData.child('L3T2167').onValue.listen((DatabaseEvent event) {
// //       DataSnapshot dataSnapshot = event.snapshot;
// //       Map<dynamic, dynamic> values = dataSnapshot.value as Map;
// //       var firebaseDB = FirebaseDBModel.fromJson(values);
// //
// //       if (firebaseDB.isTicketAssign == true) {
// //         FlutterBackgroundService().startService();
// //       } else {
// //         positionStream?.cancel();
// //         FlutterBackgroundService().invoke('stopService');
// //       }
// //
// //     });
// //   }
// //
// //   void startLocationStream() {
// //     positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
// //       String latLong = position == null ? 'Unknown' : 'Lat - ${position.latitude.toString()}, Lng - ${position.longitude.toString()}';
// //       print('>>>>>>Location Service: $latLong');
// //     });
// //   }
// //
// // }*/
