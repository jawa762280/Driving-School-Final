import 'package:driving_school/core/constant/approuts.dart';
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
    if (picked != null && isStartTime) {
      startTime.value = picked;
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

    final response = await crud.getRequest(url);
    sessions.addAll(response['data'] ?? []);
    hasFetched = true;

    isLoading.value = false;
    update();
  }

  // ✅ الآن نستقبل الجلسة كاملة لنرسل amount
  // ✅ الآن نستقبل الجلسة كاملة لنرسل amount ثم نوجّه لواجهة الدفع
  selectSessions(Map session) async {
    isLoading.value = true;
    update();

    String token = data.read('token') ?? '';

    // استخراج السعر بأمان من الجلسة
    num? fee;
    final rawFee = session['registration_fee'];
    if (rawFee is num) {
      fee = rawFee;
    } else if (rawFee != null) {
      fee = num.tryParse(rawFee.toString());
    }

    try {
      final response = await http.post(
        Uri.parse(AppLinks.autobooksession),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'session_id': session['id'],
          'transmission': vitesType, // 'automatic' / 'manual'
          'is_for_special_needs': trainingType == 'special_needs' ? '1' : '0',
          'amount': (fee != null) ? fee.toString() : null, // إرسال السعر
        }),
      );

      final body = jsonDecode(response.body);

      // نجاح الحجز
      if (response.statusCode == 201 || response.statusCode == 200) {
        // محاولات متعددة لالتقاط invoiceId حسب شكل الاستجابة
        final dynamic payment =
            body['data']?['payment'] ?? body['payment']; // مرن
        final dynamic invoiceDyn = payment?['invoiceId'] ??
            payment?['Receipt']?['Invoice'] ??
            body['invoiceId'];

        int? invoiceId;
        if (invoiceDyn is int) {
          invoiceId = invoiceDyn;
        } else if (invoiceDyn != null) {
          invoiceId = int.tryParse(invoiceDyn.toString());
        }

        // تحديد المبلغ المُستحق للواجهة
        dynamic amountDyn = payment?['apiResponse']?['json']?['Receipt']
                ?['Amount'] ??
            body['data']?['amount'] ??
            body['amount'] ??
            fee;
        int amountToPay;
        if (amountDyn is num) {
          amountToPay = amountDyn.toInt();
        } else {
          amountToPay =
              int.tryParse(amountDyn?.toString() ?? '') ?? (fee?.toInt() ?? 0);
        }

        // إيقاف اللودينغ قبل التوجيه
        isLoading.value = false;
        update();

        // التوجيه لواجهة الدفع
        if (invoiceId != null && invoiceId > 0) {
          Get.offAllNamed(
            AppRouts.paymentScreen,
            arguments: {
              'invoiceId': invoiceId,
              'amount': amountToPay,
            },
          );
        } else {
          // ما رجع رقم فاتورة — نوجّه مع المبلغ وننبه المستخدم
          Get.offAllNamed(
            AppRouts.paymentScreen,
            arguments: {
              'invoiceId':
                  0, // أو اتركه بدون تمرير لو واجهة الدفع تتطلبه إلزامياً
              'amount': amountToPay,
            },
          );
          Get.snackbar(
            'تنبيه',
            'تم الحجز بنجاح لكن لم يتم إنشاء رقم فاتورة بعد.',
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
        return;
      }

      // فشل من الخادم
      Get.snackbar(
        'حدث خطأ',
        body['message'] ?? 'حدث خطأ غير متوقع',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
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
