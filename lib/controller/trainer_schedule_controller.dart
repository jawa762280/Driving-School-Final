// ignore_for_file: avoid_print

import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TrainerScheduleController extends GetxController {
  final selectedDay = ''.obs;
  var isLoading = false.obs;

  final startTime = Rx<TimeOfDay?>(null);
  final endTime = Rx<TimeOfDay?>(null);
  final validFrom = Rx<DateTime?>(null);
  final validTo = Rx<DateTime?>(null);
  final isRecurring = true.obs;
  final Crud crud = Crud();

  final formKey = GlobalKey<FormState>();

  final Map<String, String> dayTranslations = {
    'السبت': 'saturday',
    'الأحد': 'sunday',
    'الاثنين': 'monday',
    'الثلاثاء': 'tuesday',
    'الأربعاء': 'wednesday',
    'الخميس': 'thursday',
  };
  List<String> get days => dayTranslations.keys.toList(); // ✅

  void selectDay(String day) {
    selectedDay.value = day;
  }

  Future<void> pickTime({required bool isStartTime}) async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              dialHandColor: AppColors.primaryColor,
              entryModeIconColor: AppColors.primaryColor,
              hourMinuteTextColor: AppColors.primaryColor,
              hourMinuteColor:
                  AppColors.primaryColor.withAlpha((0.1 * 255).toInt()),
              dialBackgroundColor:
                  AppColors.primaryColor.withAlpha((0.1 * 255).toInt()),
            ),
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final isValid = picked.hour >= 9 && picked.hour < 20;

      if (!isValid) {
        Get.snackbar(
            "وقت غير مسموح", "الرجاء اختيار وقت بين الساعة 9 صباحًا و 8 مساءً");
        return;
      }

      if (isStartTime) {
        startTime.value = picked;
      } else {
        endTime.value = picked;
      }
    }
  }

  Future<void> pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isFrom) {
        validFrom.value = picked;
      } else {
        validTo.value = picked;
      }
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.Hm().format(dt);
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'اختر تاريخ';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void submitSchedule() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    final trainer = data.read('user')['trainer'];
    final trainerId = trainer != null ? trainer['id']?.toString() : null;

    if (trainerId == null) {
      Get.snackbar("خطأ", "معرف المدرب غير موجود. الرجاء تسجيل الدخول مجدداً");
      return;
    }

    if (selectedDay.value.isEmpty ||
        startTime.value == null ||
        endTime.value == null ||
        validFrom.value == null ||
        validTo.value == null) {
      Get.snackbar("تنبيه", "يرجى تعبئة جميع الحقول المطلوبة");
      return;
    }

    final schedule = {
      "trainer_id": trainerId,
      "day_of_week": dayTranslations[selectedDay.value] ?? '',
      "start_time": formatTime(startTime.value),
      "end_time": formatTime(endTime.value),
      "is_recurring": isRecurring.value,
      "valid_from": formatDate(validFrom.value),
      "valid_to": formatDate(validTo.value),
    };

    final scheduleData = {
      "schedules": [schedule] // قائمة حتى لو فيها جدول واحد فقط
    };

    try {
      final response =
          await crud.postRequest(AppLinks.createSchedule, scheduleData);
      isLoading.value = false;

      if (response != null &&
          response['message']?.toString().contains("تم انشاء جدول") == true) {
        Get.snackbar("نجاح", response['message'] ?? "تم حفظ الجدول بنجاح ✅");
        resetForm();
      } else {
        Get.snackbar("خطأ", response['message'] ?? "حدث خطأ أثناء الحفظ ❌");
        print("⚠️ تفاصيل الرد: ${response.toString()}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث استثناء أثناء الحفظ ❌");
      print("❌ استثناء أثناء الطلب: ${e.toString()}");
    }
  }

  void resetForm() {
    selectedDay.value = '';
    startTime.value = null;
    endTime.value = null;
    validFrom.value = null;
    validTo.value = null;
    isRecurring.value = true;
    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    resetForm();
    super.onClose();
  }
}
