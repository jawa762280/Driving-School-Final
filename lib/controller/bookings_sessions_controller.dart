import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:get_storage/get_storage.dart';

class BookingsSessionsController extends GetxController {
  final Crud crud = Crud();
  var userRole = ''.obs;

  var sessions = [].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var errorMessage = ''.obs;
  var startedSessions = <bool>[].obs;
  final GetStorage data = GetStorage();
  String level = '';
  int levelCount = 0;
  TextEditingController comment = TextEditingController();
  double rating = 3;

  @override
  void onInit() {
    super.onInit();
    userRole.value = data.read('role') ?? 'student';
    if (data.read('student-review') == null) {
      data.write('student-review', []);
    }
    fetchSessions();
  }

  sendFeedback(id) async {
    var response = await crud.postRequest(AppLinks.feedbackStudent, {
      'booking_id': id,
      'level': level,
      'notes': comment.text,
    });
    if (response['status'] == 'success') {
      Get.snackbar("نجاح", 'تم ارسال التقييم',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          duration: Duration(seconds: 2));
    }
    update();
  }

  sendFeedbackStudent(id) async {
    var response = await crud.postRequest(AppLinks.trainerReviews, {
      'trainer_id': id,
      'comment': comment.text,
      'rating': rating,
    });
    // ignore: avoid_print
    print('MyResponse $response');
    if (response['status'] == true) {
      Get.back();
      List<dynamic> reviews = data.read('student-review') ?? [];
      reviews.add({
        'trainer_id': id,
        'rating': rating.toString(),
        'comment': comment.text,
      });
      data.write('student-review', reviews);
      update();
    }
    update();
  }

  Future<void> fetchSessions() async {
    isLoading.value = true;
    error.value = '';

    String url;
    if (userRole.value == 'trainer') {
      url = AppLinks.bookingSessionsTrainer;
    } else {
      url = AppLinks.bookingSessionsStudent;
    }

    final response = await crud.getRequest(url);

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
          duration: Duration(seconds: 2));
      await fetchSessions(); // إعادة تحميل الجلسات
    } else {
      final errorMsg = response?['message'] ?? 'فشل في إلغاء الجلسة';
      Get.snackbar("خطأ", errorMsg,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          duration: Duration(seconds: 2));
    }
  }

  Future<void> startSession(int bookingId) async {
    final response =
        await crud.postRequest("${AppLinks.startSession}/$bookingId/start", {});

    if (response != null && response['message'] != null) {
      Get.snackbar("نجاح", response['message'],
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          duration: Duration(seconds: 2));

      await fetchSessions(); // إعادة تحميل الجلسات
    } else {
      final errorMsg = response?['message'] ?? 'فشل بدء الجلسة';
      Get.snackbar("خطأ", errorMsg,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          duration: Duration(seconds: 2));
    }
  }

  Future<void> completeSession(int bookingId) async {
    final response = await crud
        .postRequest("${AppLinks.completeSession}/$bookingId/complete", {});

    if (response != null && response['message'] != null) {
      Get.snackbar("نجاح", response['message'],
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          duration: Duration(seconds: 2));

      await fetchSessions(); // إعادة تحميل الجلسات
    } else {
      final errorMsg = response?['message'] ?? 'فشل إنهاء الجلسة';
      Get.snackbar("خطأ", errorMsg,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          duration: Duration(seconds: 2));
    }
  }
}
