import 'package:driving_school/core/functions/background_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:get_storage/get_storage.dart';

class BookingsSessionsController extends GetxController {
  final Crud crud = Crud();
  var userRole = ''.obs;

  TextEditingController comment = TextEditingController();

  var sessions = [].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var errorMessage = ''.obs;
  var startedSessions = <bool>[].obs;
  final GetStorage data = GetStorage();
  String level = 'beginner';
  int levelCount = 0;
  var reviews = <dynamic>[].obs;

  // ✅ لتتبع أي جلسة مفعّل عليها التتبع
  int? _activeTrackingBookingId;

  @override
  void onInit() {
    super.onInit();
    userRole.value = data.read('role') ?? 'student';

    if (data.read('role').toString() == 'trainer') {
      getReviews();
    }
    if (data.read('role').toString() == 'student') {
      getReviewsStudent();
    }

    fetchSessions();
  }

  getReviews() async {
    var response = await crud.getRequest(AppLinks.trainerFeedbacks);
    reviews.clear();
    reviews.addAll(response['data']);
    update();
  }

  getReviewsStudent() async {
    var response = await crud.getRequest(AppLinks.studentFeedbacks);
    reviews.clear();
    reviews.addAll(response['data']);
    update();
  }

  sendFeedback(id) async {
    isLoading.value = true;
    try {
      var response = await crud.postRequest(AppLinks.feedbackStudent, {
        'booking_id': id,
        'level': level,
        'notes': comment.text,
      });

      if (response['level'].toString() != 'null') {
        Get.snackbar(
          "نجاح",
          'تم ارسال التقييم',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          duration: const Duration(seconds: 2),
        );
        getReviews();
        fetchSessions();
        resetFeedbackForm();

        update();
        Navigator.pop(Get.context!);
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء إرسال التقييم");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void resetFeedbackForm() {
    level = 'beginner';
    comment.clear();
  }

  // ignore: prefer_typing_uninitialized_variables
  var response;
  Future<void> fetchSessions() async {
    isLoading.value = true;
    error.value = '';

    String url;
    if (userRole.value == 'trainer') {
      url = AppLinks.bookingSessionsTrainer;
    } else {
      url = AppLinks.bookingSessionsStudent;
    }

    response = await crud.getRequest(url);

    isLoading.value = false;
    if (response != null && response['data'] != null) {
      sessions.value = response['data'];
      startedSessions.value = List.generate(sessions.length, (_) => false);
    } else {
      error.value = response?['message'] ?? 'حدث خطأ أثناء جلب الجلسات';
    }
  }

  Future<void> cancelSession(int sessionId) async {
    final response = await crud
        .postRequest("${AppLinks.cancelSession}/$sessionId/cancel", {});

    if (response != null && response['status'] == true) {
      Get.snackbar("نجاح", response['message'],
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          duration: const Duration(seconds: 2));
      await fetchSessions();
    } else {
      final errorMsg = response?['message'] ?? 'فشل في إلغاء الجلسة';
      Get.snackbar("خطأ", errorMsg,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          duration: const Duration(seconds: 2));
    }
  }

  Future<void> startSession(int bookingId) async {
    final response =
        await crud.postRequest("${AppLinks.startSession}/$bookingId/start", {});

    if (response != null && response['message'] != null) {
      Get.snackbar("نجاح", response['message'],
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          duration: const Duration(seconds: 2));

      // ✅ ابدأ تتبع الخلفية فوراً لهالجلسة
      await _startTrackingForBooking(bookingId);

      await fetchSessions();
    } else {
      final errorMsg = response?['message'] ?? 'فشل بدء الجلسة';
      Get.snackbar("خطأ", errorMsg,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          duration: const Duration(seconds: 2));
    }
  }

  Future<void> completeSession(int bookingId) async {
    final response = await crud
        .postRequest("${AppLinks.completeSession}/$bookingId/complete", {});

    if (response != null && response['message'] != null) {
      Get.snackbar("نجاح", response['message'],
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          duration: const Duration(seconds: 2));

      // ✅ أوقف تتبع الخلفية إن كانت لنفس الجلسة
      await _stopTrackingIfActive(bookingId);

      await fetchSessions();
    } else {
      final errorMsg = response?['message'] ?? 'فشل إنهاء الجلسة';
      Get.snackbar("خطأ", errorMsg,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          duration: const Duration(seconds: 2));
    }
  }

  // ----------------- Helpers -----------------

  // يحوّل أي قيمة إلى int إذا أمكن
  int? _toInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
    }

  // استخرج session_id و car_id من عنصر الجلسة
  Ids? _extractIdsForBooking(int bookingId) {
    for (final e in sessions) {
      if (e is Map && e['id'] == bookingId) {
        final dynamic s1 = e['session']?['id'];
        final dynamic s2 = e['session_id'];
        final dynamic s3 = e['id']; // fallback
        final dynamic c1 = e['car']?['id'];
        final dynamic c2 = e['car_id'];

        final sid = _toInt(s1) ?? _toInt(s2) ?? _toInt(s3);
        final cid = _toInt(c1) ?? _toInt(c2);

        if (sid != null && cid != null) return Ids(sid, cid);
        break;
      }
    }
    return null;
  }

  Future<void> _startTrackingForBooking(int bookingId) async {
    final ids = _extractIdsForBooking(bookingId);
    if (ids == null) {
      Get.snackbar("تنبيه",
          "تعذر بدء إرسال الموقع: session_id أو car_id غير موجود.",
          backgroundColor: Colors.yellow.shade100,
          colorText: Colors.black,
          duration: const Duration(seconds: 2));
      return;
    }

    try {
      await initializeBackgroundService(
        sessionId: ids.sessionId,
        carId: ids.carId,
      );
      _activeTrackingBookingId = bookingId;
    } catch (e) {
      Get.snackbar("خطأ", "تعذر بدء تتبع الموقع: $e",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          duration: const Duration(seconds: 2));
    }
  }

  Future<void> _stopTrackingIfActive(int bookingId) async {
    if (_activeTrackingBookingId == bookingId) {
      await stopBackgroundService();
      _activeTrackingBookingId = null;
    }
  }
}

class Ids {
  final int sessionId;
  final int carId;
  Ids(this.sessionId, this.carId);
}
