
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapPageController extends GetxController {
  final Crud crud = Crud();
  List<LatLng> routePoints = [];

  Future<void> fetchRouteForBooking({
    required int bookingId,
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    // ignore: avoid_print
    print('🔄 fetchRouteForBooking called for booking $bookingId');

    try {
      final resp = await crud.postRequest(
        '${AppLinks.defineRoute}/$bookingId/route',
        {
          'start_lat': startLat,
          'start_lng': startLng,
          'end_lat': endLat,
          'end_lng': endLng,
        },
      );

      final success = resp['success'] == true || resp['status'] == true;
      if (!success) {
        final msg = resp['message'] ?? 'فشل في جلب المسار';
        // ignore: avoid_print
        print('⚠️ API error: $msg');
        Get.snackbar('خطأ', msg, snackPosition: SnackPosition.BOTTOM);
        routePoints = [];
        update();
        return;
      }

      final data = resp['data'];
      if (data == null || data['polyline'] == null) {
        // ignore: avoid_print
        print('⚠️ API returned no polyline.');
        Get.snackbar('خطأ', 'لم يتم العثور على بيانات المسار', snackPosition: SnackPosition.BOTTOM);
        routePoints = [];
        update();
        return;
      }

      final encoded = data['polyline'] as String;
      final decoded = PolylinePoints().decodePolyline(encoded);
      // ignore: avoid_print
      print('🔵 Decoded ${decoded.length} points');

      routePoints = decoded
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      update(); 
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ Exception in fetchRouteForBooking: $e');
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع', snackPosition: SnackPosition.BOTTOM);
      routePoints = [];
      update();
    }
  }
}
