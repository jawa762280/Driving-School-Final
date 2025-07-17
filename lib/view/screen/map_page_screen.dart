// lib/view/screen/map_page_screen.dart

import 'package:driving_school/controller/bookings_sessions_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPageScreen extends StatefulWidget {
  final int bookingId;
  final double? startLat;
  final double? startLng;
  final double? endLat;
  final double? endLng;
  const MapPageScreen({
    super.key,
    required this.bookingId, this.startLat, this.startLng, this.endLat, this.endLng,
  });

  @override
  State<MapPageScreen> createState() => _MapPageScreenState();
}

class _MapPageScreenState extends State<MapPageScreen> {
  // 1. جلب الكنترولر
  final controller = Get.find<BookingsSessionsController>();

  LatLng? _myLocation;
  LatLng? _point1;
  LatLng? _point2;

  late final MapController _mapController;
  final Distance _distance = const Distance();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    // 2. الحصول على موقع المستخدم فور فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getMyLocation();
    });
  }

  Future<void> _getMyLocation() async {
  // 1) تأكد أنّ خدمة المواقع مفعّلة
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Get.snackbar('خطأ', 'يرجى تشغيل خدمة الموقع على الجهاز');
    return;
  }

  // 2) تحقق من الصلاحيات الحالية
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // المستخدم رفض الطلب
      Get.snackbar('صلاحية مرفوضة', 'لا يمكن الوصول إلى موقعك دون صلاحية');
      return;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // مرفوض نهائيّاً—ارشد المستخدم لإعدادات التطبيق
    Get.snackbar(
      'صلاحية مرفوضة نهائيّاً',
      'اذهب للإعدادات وفعّل صلاحية الموقع للتطبيق',
      mainButton: TextButton(
        child: const Text('الإعدادات'),
        onPressed: Geolocator.openAppSettings,
      ),
    );
    return;
  }

  // 3) الصلاحيات متوفرة، أعد الموقع
  try {
    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() => _myLocation = LatLng(pos.latitude, pos.longitude));
    _mapController.move(_myLocation!, 15);
  } catch (e) {
    Get.snackbar('خطأ', 'فشل في جلب الموقع: $e');
  }
}


  void _handleTap(LatLng tappedPoint) {
    setState(() {
      if (_point1 == null) {
        _point1 = tappedPoint;
      } else if (_point2 == null) {
        _point2 = tappedPoint;
      } else {
        _point1 = tappedPoint;
        _point2 = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[];
    if (_myLocation != null) {
      markers.add(Marker(
        point: _myLocation!,
        width: 40,
        height: 40,
        child: const Icon(Icons.my_location, color: Colors.blue, size: 40),
      ));
    }
    if (_point1 != null) {
      markers.add(Marker(
        point: _point1!,
        width: 40,
        height: 40,
        child: const Icon(Icons.location_on, color: Colors.green, size: 40),
      ));
    }
    if (_point2 != null) {
      markers.add(Marker(
        point: _point2!,
        width: 40,
        height: 40,
        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
      ));
    }

    final polylines = <Polyline>[];
    if (_point1 != null && _point2 != null) {
      // خطّ بين النقطتين أثناء التحديد
      polylines.add(Polyline(
        points: [_point1!, _point2!],
        color: Colors.red,
        strokeWidth: 4,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('الخريطة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 6,
        shadowColor: Colors.black45,
      ),
      body: _myLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _myLocation!,
                    initialZoom: 15,
                    onTap: (_, latlng) => _handleTap(latlng),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.driving.school',
                    ),
                    PolylineLayer(polylines: polylines),
                    MarkerLayer(markers: markers),
                  ],
                ),
                if (_point1 != null && _point2 != null)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.all(12.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'المسافة: ${_distance.as(LengthUnit.Kilometer, _point1!, _point2!).toStringAsFixed(2)} km',
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

      // 3. هنا زرّ التأكيد اللي يرسل الإحداثيات للـ API
      floatingActionButton: (_point1 != null && _point2 != null)
          ? FloatingActionButton(
              child: const Icon(Icons.check),
              backgroundColor: AppColors.primaryColor,
              onPressed: () async {
                try {
                  // استدعاء الدالة اللي أضفتها في الكنترولر
                  await controller.fetchRouteForBooking(
                    widget.bookingId,
                    startLat: _point1!.latitude,
                    startLng: _point1!.longitude,
                    endLat: _point2!.latitude,
                    endLng: _point2!.longitude,
                  );
                  // نجاح → ارجع وحدثّ الجلسات
                  Get.back(result: true);
                } catch (_) {
                  Get.snackbar(
                    'خطأ',
                    'لم نتمكن من حفظ المسار، حاول مرة أخرى',
                    backgroundColor: Colors.red.shade100,
                    colorText: Colors.black,
                  );
                }
              },
            )
          : null,
    );
  }
}
