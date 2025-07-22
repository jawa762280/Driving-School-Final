// lib/view/screen/map_page_screen.dart

import 'dart:async';
import 'dart:convert';
import 'package:driving_school/controller/map_page_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

Timer? _locationServiceChecker;
bool _alreadyRequestedLocation = false;

class MapPageScreen extends StatefulWidget {
  final int bookingId;
  final bool? isStudent;
  final double? startLat, startLng, endLat, endLng;
  final String? distanceMetres, durationInSeconds, startAdress, endAdress;
  final String? existingPolyline;

  const MapPageScreen({
    super.key,
    required this.bookingId,
    this.isStudent,
    this.startLat,
    this.startLng,
    this.endLat,
    this.endLng,
    this.distanceMetres,
    this.durationInSeconds,
    this.startAdress,
    this.endAdress,
    this.existingPolyline,
  });

  @override
  State<MapPageScreen> createState() => _MapPageScreenState();
}

class _MapPageScreenState extends State<MapPageScreen> {
  late final MapController _mapController;
  late final MapPageController _ctrl;
  LatLng? _myLocation, _point1, _point2;
  final Distance _distance = const Distance();
  List<LatLng> routePoints = [];
  Map<String, dynamic>? results;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _ctrl = Get.put(MapPageController());
    _determinePosition();

    // إعادة محاولة تحديد الموقع
    _locationServiceChecker =
        Timer.periodic(const Duration(seconds: 3), (timer) async {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled && !_alreadyRequestedLocation && _myLocation == null) {
        _alreadyRequestedLocation = true;
        await _determinePosition();
      }
    });

    // مسار API موجود مسبقاً (polyline)
    if (widget.existingPolyline != null) {
      final decoded = PolylinePoints().decodePolyline(widget.existingPolyline!);
      _ctrl.routePoints =
          decoded.map((p) => LatLng(p.latitude, p.longitude)).toList();
      _ctrl.update();
    }
  }

  @override
  void dispose() {
    _locationServiceChecker?.cancel();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      Get.snackbar('خطأ', 'يرجى تشغيل خدمة الموقع على الجهاز');
      return;
    }
    var perm = await Geolocator.checkPermission();
    perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied) {
      Get.snackbar('صلاحية مرفوضة', 'لا يمكن الوصول إلى موقعك');
      return;
    }
    if (perm == LocationPermission.deniedForever) {
      Get.snackbar(
        'صلاحية مرفوضة نهائيًّا',
        'اذهب للإعدادات وفعّل صلاحية الموقع',
        mainButton: TextButton(
          onPressed: Geolocator.openAppSettings,
          child: const Text('الإعدادات'),
        ),
      );
      return;
    }
    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() => _myLocation = LatLng(pos.latitude, pos.longitude));
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      if (_point1 == null) {
        _point1 = tappedPoint;
      } else if (_point2 == null) {
        _point2 = tappedPoint;
        // جلب ورسم المسار اليدوي باستخدام OSRM
        getRoute(_point1!, _point2!).then((pts) {
          setState(() => routePoints = pts);
        }).catchError((_) {
          Get.snackbar('خطأ', 'تعذّر جلب المسار');
        });
        getRouteWithInfo(_point1!, _point2!).then((info) {
          setState(() => results = info);
        }).catchError((_) {
          Get.snackbar('خطأ', 'تعذّر جلب معلومات المسار');
        });
      } else {
        // إعادة التحديد إذا نقرت ثالثة
        _point1 = tappedPoint;
        _point2 = null;
        routePoints.clear();
        results = null;
      }
    });
  }

  /// يستخدم OSRM العام (بدون API Key)
  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final url = 'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${end.longitude},${end.latitude}'
        '?overview=full&geometries=geojson';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) {
      throw Exception('OSRM ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body);
    final coords = (data['routes'][0]['geometry']['coordinates'] as List)
        .cast<List<dynamic>>();
    return coords.map((c) => LatLng(c[1], c[0])).toList();
  }

  Future<Map<String, dynamic>> getRouteWithInfo(
      LatLng start, LatLng end) async {
    final url = 'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${end.longitude},${end.latitude}'
        '?overview=false';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) {
      throw Exception('OSRM info ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body);
    final route = data['routes'][0];
    return {
      'distance': route['distance'], // بالأمتار
      'duration': route['duration'], // بالثواني
    };
  }

  @override
  Widget build(BuildContext context) {
    // اختر المسار: API أولاً وإلا اليدوي
    final currentRoute =
        _ctrl.routePoints.isNotEmpty ? _ctrl.routePoints : routePoints;

    // نقطة المنتصف لبطاقة المعلومات
    LatLng? midpoint;
    if (currentRoute.isNotEmpty) {
      midpoint = currentRoute[currentRoute.length ~/ 2];
    }

    // دقائق API
    int? apiMinutes;
    if (widget.durationInSeconds != null) {
      apiMinutes = (int.parse(widget.durationInSeconds!) / 60).ceil();
    }

    // دقائق المسار اليدوي
    int? manualMinutes;
    if (results != null) {
      manualMinutes = (results!['duration'] / 60).ceil();
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        title: const Text('الخريطة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: (_myLocation == null && currentRoute.isEmpty)
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onTap: widget.endLat != null || widget.isStudent == true
                    ? null
                    : (_, p) => _handleTap(p),
                initialCenter: _myLocation ?? LatLng(0, 0),
                initialZoom: 15,
                onMapReady: () {
                  if (currentRoute.isNotEmpty) {
                    _mapController.move(currentRoute.first, 15);
                  } else if (_myLocation != null) {
                    _mapController.move(_myLocation!, 15);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.driving.school',
                ),

                // 1) المسار اليدوي بالأخضر
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                          points: routePoints,
                          strokeWidth: 4,
                          color: Colors.green)
                    ],
                  ),

                // 2) مسار الـ API بالأزرق
                if (_ctrl.routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                          points: _ctrl.routePoints,
                          strokeWidth: 4,
                          color: Colors.blue)
                    ],
                  ),

                // 3) العلامات (Markers)
                MarkerLayer(markers: [
                  if (_myLocation != null)
                    Marker(
                        point: _myLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.my_location,
                            color: Colors.blue, size: 40)),
                  if (_point1 != null)
                    Marker(
                        point: _point1!,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_on,
                            color: Colors.green, size: 40)),
                  if (_point2 != null)
                    Marker(
                        point: _point2!,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_on,
                            color: Colors.red, size: 40)),
                  if (_ctrl.routePoints.isNotEmpty &&
                      widget.startAdress != null)
                    Marker(
                        point: _ctrl.routePoints.first,
                        width: 200,
                        height: 100,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.location_on,
                              color: Colors.green, size: 40),
                          const SizedBox(height: 4),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(widget.startAdress!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2)))
                        ])),
                  if (_ctrl.routePoints.isNotEmpty && widget.endAdress != null)
                    Marker(
                        point: _ctrl.routePoints.last,
                        width: 200,
                        height: 100,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.location_on,
                              color: Colors.red, size: 40),
                          const SizedBox(height: 4),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(widget.endAdress!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2)))
                        ])),
                  if (midpoint != null)
                    Marker(
                        point: midpoint,
                        width: 160,
                        height: 60,
                        child: Transform.translate(
                            offset: const Offset(0, -50),
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.alt_route,
                                          size: 13,
                                          color: AppColors.primaryColor),
                                      const SizedBox(width: 4),
                                      Text(
                                          _ctrl.routePoints.isNotEmpty
                                              ? '${widget.distanceMetres} كم'
                                              : '${_distance.as(LengthUnit.Kilometer, _point1!, _point2!).toStringAsFixed(1)} كم',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(width: 12),
                                      Icon(Icons.access_time,
                                          size: 13,
                                          color: AppColors.primaryColor),
                                      const SizedBox(width: 4),
                                      Text(
                                          _ctrl.routePoints.isNotEmpty
                                              ? '${apiMinutes ?? 0} د'
                                              : '${manualMinutes ?? 0} د',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600))
                                    ]))))
                ]),
              ],
            ),
      floatingActionButton: (_point1 != null && _point2 != null)
          ? FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () async {
                // افتح الديالوج
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Dialog(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.green,
                                ),
                                SizedBox(width: 16),
                                Text('جاري تحديد المسار...')
                              ],
                            ),
                          ),
                        ));
                try {
                  await _ctrl.fetchRouteForBooking(
                    bookingId: widget.bookingId,
                    startLat: _point1!.latitude,
                    startLng: _point1!.longitude,
                    endLat: _point2!.latitude,
                    endLng: _point2!.longitude,
                  );
                  // اغلق الديالوج
                  Navigator.of(context).pop();
                  // اظهر تأكيد
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: const Text('تم'),
                            content:
                                const Text('لقد تمّ تحديد مسار التدريب بنجاح.'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('حسناً'))
                            ],
                          ));
                } catch (_) {
                  // اغلق الديالوج
                  Navigator.of(context).pop();
                  Get.snackbar(
                    'خطأ',
                    'لم نتمكن من حفظ المسار، حاول مرة أخرى',
                    backgroundColor: Colors.red.shade100,
                    colorText: Colors.black,
                  );
                }
              },
              child: const Icon(Icons.check, color: Colors.white),
            )
          : null,
    );
  }
}
