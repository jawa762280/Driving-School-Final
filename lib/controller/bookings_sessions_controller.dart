import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';

class BookingsSessionsController extends GetxController {
  final Crud crud = Crud();

  var sessions = [].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var errorMessage = ''.obs;
  var startedSessions = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrainerSessions();
  }

  Future<void> fetchTrainerSessions() async {
    isLoading.value = true;
    error.value = '';

    final response =
        await crud.getRequest(AppLinks.bookingSessions); // تأكد إن الرابط صحيح

    isLoading.value = false;

    if (response != null && response['data'] != null) {
      sessions.value = response['data'];
      startedSessions.value = List.generate(sessions.length, (_) => false);
    } else {
      error.value = response?['message'] ?? 'حدث خطأ أثناء جلب الجلسات';
    }
  }

  Future<void> cancelSession(int sessionId) async {
    final response = await crud.postRequest("${AppLinks.cancelSession}/$sessionId/cancel", {});

    if (response != null && response['status'] == true) {
      Get.snackbar("نجاح", response['message'],
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          duration: Duration(seconds: 2));
      await fetchTrainerSessions(); // إعادة تحميل الجلسات
    } else {
      final errorMsg = response?['message'] ?? 'فشل في إلغاء الجلسة';
      Get.snackbar("خطأ", errorMsg,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          duration: Duration(seconds: 2));
    }
  }
}
