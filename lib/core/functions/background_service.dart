import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constant/app_api.dart';
import '../services/crud.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> setupNotificationChannel() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'location_channel', 
    'Location Tracking',
    description: 'Tracks location in background',
    importance: Importance.low,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> initializeBackgroundService() async {
  await Geolocator.requestPermission();
  await Permission.locationAlways.request();

  await setupNotificationChannel();

  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'location_channel',
      initialNotificationTitle: 'مدرسة القيادة',
      initialNotificationContent: 'تتبع الموقع في الخلفية',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: (service) => true,
    ),
  );

  await service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  bool serviceRunning = true;

  service.on("stopService").listen((event) {
    serviceRunning = false;
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (!serviceRunning) {
      timer.cancel();
      return;
    }

    final enabled = await Geolocator.isLocationServiceEnabled();
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (!enabled || permission == LocationPermission.deniedForever) {
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print("موقعي: ${pos.latitude}, ${pos.longitude}");

    final crud = Crud();
    final response = await crud.postRequest(AppLinks.carLocations, {
      "car_id": '3',
      "latitude": pos.latitude,
      "longitude": pos.longitude,
      "recorded_at": '20-05-2001',
    });

    print("Response: $response");
  });
}
