import 'package:driving_school/core/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constant/app_api.dart';
import '../main.dart';

class ChooseOtomatikController extends GetxController {
  var isLoading = false.obs;
  bool hasFetched = false;

  final selectedDay = ''.obs;
  final startTime = Rx<TimeOfDay?>(null);
  final startDate = Rx<DateTime?>(null);
  Crud crud = Crud();
  List sessions = [];
  final Map<String, String> dayTranslations = {
    'السبت': 'saturday',
    'الأحد': 'sunday',
    'الاثنين': 'monday',
    'الثلاثاء': 'tuesday',
    'الأربعاء': 'wednesday',
    'الخميس': 'thursday',
  };
  List<String> get days => dayTranslations.keys.toList();
  String trainingType = '';
  String vitesType = '';
  void selectDay(String day) {
    selectedDay.value = day;
    update();
  }

  Future<void> pickTime({required bool isStartTime}) async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (isStartTime) {
        startTime.value = picked;
      }
    }
    update();
  }

  Future<void> pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      startDate.value = picked;
      update();
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

  getSessions() async {
    isLoading.value = true;
    update();
    sessions.clear();
    final url = '${AppLinks.recommendedSessions}'
        '?preferred_date=${formatDate(startDate.value)}'
        '&preferred_time=${formatTime(startTime.value)}'
        '&training_type=$trainingType';
    var response = await crud.getRequest(url);
    sessions.addAll(response['data']);
    hasFetched = true;
    update();

    isLoading.value = false;
    update();
  }

  selectSessions(id) async {
    isLoading.value = true;
    String token = data.read('token') ?? '';
    try {
      final response = await http.post(
        Uri.parse(AppLinks.autobooksession),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'session_id': id,
          'transmission': vitesType,
          'is_for_special_needs': trainingType == 'special_needs' ? '1' : '0',
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['data'] != null &&
          data['data'].isNotEmpty) {
        Get.snackbar(
          'تمت العملية بنجاح',
          'تم حجز الجلسة بنجاح',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        Get.snackbar(
          'حدث خطأ',
          data['message'] ?? 'حدث خطأ غير متوقع',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ في الاتصال',
        'حدث خطأ أثناء الاتصال بالخادم',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
    isLoading.value = false;
    update();
  }
}
