import 'package:driving_school/core/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../core/constant/app_api.dart';

class ChooseOtomatikController extends GetxController {
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
    sessions.clear();
    final url = '${AppLinks.recommendedSessions}'
        '?preferred_date=${formatDate(startDate.value)}'
        '&preferred_time=${formatTime(startTime.value)}'
        '&training_type=$trainingType';
    var response = await crud.getRequest(url);
    sessions.addAll(response['data']);
    update();
  }
}
