import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

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

/// تناديها عند "بدء الجلسة"
Future<void> initializeBackgroundService({
  required int sessionId,
  required int carId,
}) async {
  await Geolocator.requestPermission();
  await Permission.locationAlways.request(); // لأندرويد 10+
  await setupNotificationChannel();

  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false, // لا تبدأ تلقائياً
      notificationChannelId: 'location_channel',
      initialNotificationTitle: 'مدرسة القيادة',
      initialNotificationContent: 'تتبع الموقع في الخلفية',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground, // ✅ لازم دالة ترجع Future<bool>
    ),
  );

  await service.startService();
  await Future.delayed(const Duration(milliseconds: 300));
  service.invoke('config', {
    'session_id': sessionId,
    'car_id': carId,
  });
}

/// تناديها عند "إنهاء الجلسة"
Future<void> stopBackgroundService() async {
  final service = FlutterBackgroundService();
  service.invoke('stopService');
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  // سنملأها من UI عبر event 'config'
  int? sessionId;
  int? carId;

  service.on('config').listen((event) {
    final sid = event?['session_id'];
    final cid = event?['car_id'];
    sessionId = sid is int ? sid : int.tryParse('$sid');
    carId = cid is int ? cid : int.tryParse('$cid');
  });

  service.on('stopService').listen((_) async {
    await _posSub?.cancel();
    _posSub = null;
    service.stopSelf();
  });

  await _startPositionStream(
    service: service,
    getSessionId: () => sessionId,
    getCarId: () => carId,
  );
}

// ====== حالة على مستوى isolate ======
StreamSubscription<Position>? _posSub;
DateTime? _lastSent;

// بدء بث المواقع + الإرسال
Future<void> _startPositionStream({
  required ServiceInstance service,
  required int? Function() getSessionId,
  required int? Function() getCarId,
}) async {
  final gpsOn = await Geolocator.isLocationServiceEnabled();
  var perm = await Geolocator.checkPermission();
  if (perm == LocationPermission.denied) {
    perm = await Geolocator.requestPermission();
  }
  if (!gpsOn || perm == LocationPermission.deniedForever) {
    return;
  }

  const settings = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 10, // أرسل بعد ~10م
  );

  _posSub?.cancel();
  _posSub = Geolocator.getPositionStream(locationSettings: settings).listen(
    (pos) async {
      final now = DateTime.now();
      if (_lastSent != null &&
          now.difference(_lastSent!) < const Duration(seconds: 5)) {
        return; // throttle
      }

      final sid = getSessionId();
      final cid = getCarId();
      if (sid == null || cid == null) return;

      final recordedAt = (pos.timestamp ?? DateTime.now()).toUtc();
      final body = {
        "car_id": cid,
        "session_id": sid,
        "latitude": pos.latitude,
        "longitude": pos.longitude,
        "recorded_at": DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(recordedAt),
      };

      try {
        final crud = Crud();
        await crud.postRequest(AppLinks.carLocations, body);
        _lastSent = now;

        if (service is AndroidServiceInstance) {
          service.setForegroundNotificationInfo(
            title: 'مدرسة القيادة',
            content:
                'جلسة $sid | ${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}',
          );
        }
      } catch (_) {
        // ممكن إضافة Queue لاحقاً
      }
    },
  );
}
