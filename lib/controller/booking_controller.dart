import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';

class BookingController extends GetxController {
  final Crud crud = Crud();

  int? sessionId;

  var isBooking = false.obs;
  var bookingResult = Rxn<Map<String, dynamic>>();
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args != null && args['mode'] == 'booking') {
      if (args['session_id'] != null) {
        sessionId = args['session_id'];
      } else {
        error.value = 'لم يتم تمرير رقم الجلسة';
      }
    } else {
      // الحالة: فقط عرض السيارات، بدون حجز
      sessionId = null;
    }
  }

  Future<void> bookTrainingSession(int carId) async {
    if (sessionId == null) {
      error.value = 'الجلسة غير معروفة';
      return;
    }

    isBooking(true);
    error.value = '';
    bookingResult.value = null;

    final response = await crud.postRequest(
      AppLinks.booking,
      {
        "car_id": carId.toString(),
        "session_id": sessionId.toString(),
      },
    );

    isBooking(false);

    if (response != null && response['data'] != null) {
      bookingResult.value = response['data'];

      Get.offAllNamed(AppRouts.studentHomePageScreen);
      Get.snackbar("نجاح", response['message'] ?? "تم الحجز");
    } else if (response != null && response['errors'] != null) {
      // ✅ في حال وجود أخطاء تحقق من السيرفر
      final carError = response['errors']?['car']?[0];

      String errorMessage = "فشل في الحجز";
      if (carError != null && carError.toString().contains('غير متاحة')) {
        errorMessage =
            'عفوًا، السيارة غير متاحة للحجز. الرجاء اختيار سيارة أخرى.';
      } else if (response['message'] != null) {
        errorMessage = response['message'];
      }

      error.value = errorMessage;

      Get.snackbar(
        "خطأ",
        errorMessage,
        snackPosition: SnackPosition.TOP,
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      // ❌ خطأ غير معروف
      error.value = response?['message'] ?? "فشل في الحجز";

      Get.snackbar(
        "خطأ",
        error.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }
}
