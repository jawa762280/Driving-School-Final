import 'dart:io';

import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/view/screen/payment_phone_screen.dart'; // 👈 الانتقال لشاشة الدفع
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RequestLicenceController extends GetxController {
  // حالات
  final RxBool isLoading = false.obs;
  final RxBool isPageLoading = false.obs;

  // حقول الإدخال
  final TextEditingController licenceCodeController = TextEditingController();
  final TextEditingController licenceTypeController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // خدمات
  final Crud crud = Crud();

  // بيانات من API
  final List licenceTypes = [];

  // أنواع الرخص
  final List<Map<String, String>> licenceCode = const [
    {'type': 'private_b',      'name': 'رخصة خصوصي ب (عادي)'},
    {'type': 'private_b1',     'name': 'رخصة خصوصي ب1 (أوتوماتيك)'},
    {'type': 'public_c',       'name': 'رخصة ج (عمومي)'},
    {'type': 'bus_d1',         'name': 'رخصة د1 (باص كبير)'},
    {'type': 'truck_d2',       'name': 'رخصة د2 (قاطرة ومقطورة)'},
    {'type': 'motor_a',        'name': 'رخصة أ (دراجة نارية)'},
    {'type': 'construction_e', 'name': 'رخصة أشغال (تريكسات)'},
    {'type': 'test',           'name': 'رخصة تجريبية'}, // جديد
  ];

  // ملفات المستندات (ديناميكي)
  final RxList<File?> files = <File?>[].obs;

  Future<void> pickFile(int index) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      if (index >= 0 && index < files.length) {
        files[index] = File(result.files.single.path!);
        files.refresh();
      }
    }
    update();
  }

  void refreshData() {
    if (licenceCodeController.text.isNotEmpty) {
      getLicences();
    } else {
      Get.snackbar('تنبيه', 'يرجى اختيار نوع الرخصة أولاً',
          colorText: Colors.black, snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> getLicences() async {
    isPageLoading.value = true;

    final response = await crud
        .getRequest('${AppLinks.licenses}?code=${licenceCodeController.text}');

    if (response['status'] == 'success') {
      licenceTypes
        ..clear()
        ..addAll(response['data']);

      // ضبط عدد الملفات بحسب المستندات المطلوبة
      final List docs = (licenceTypes.isNotEmpty
              ? (licenceTypes[0]['required_documents'] as List?)
              : []) ??
          [];
      files.assignAll(List<File?>.filled(docs.length, null));

      // تعبئة المبلغ من registration_fee (قراءة فقط)
      final String fee = licenceTypes.isNotEmpty
          ? (licenceTypes[0]['registration_fee']?.toString() ?? '0')
          : '0';
      amountController.text = fee;
    } else {
      files.clear();
      amountController.clear();
    }

    isPageLoading.value = false;
    update();
  }

  Future<void> sendRequest() async {
  if (licenceCodeController.text.isEmpty) {
    Get.snackbar('تنبيه', 'الرجاء اختيار نوع الرخصة',
        snackPosition: SnackPosition.TOP);
    return;
  }
  if (licenceTypeController.text.isEmpty) {
    Get.snackbar('تنبيه', 'الرجاء اختيار نوع الطلب',
        snackPosition: SnackPosition.TOP);
    return;
  }

  final String amtStr = amountController.text.trim();
  final int amount = int.tryParse(amtStr) ?? 0;
  if (amount <= 0) {
    Get.snackbar('تنبيه', 'المبلغ غير صالح', snackPosition: SnackPosition.TOP);
    return;
  }

  isLoading.value = true;

  // تجهيز الملفات
  final List<XFile> uploadFiles = [];
  final List<String> fieldNames = [];
  for (int i = 0; i < files.length; i++) {
    final f = files[i];
    if (f != null) {
      uploadFiles.add(XFile(f.path));
      fieldNames.add('required_documents[$i]');
    }
  }

  final response = await crud.multiFileRequestMoreImagePath(
    AppLinks.licenseRequest,
    {
      'license_code': licenceCodeController.text,
      'type': licenceTypeController.text,
      'amount': amount.toString(),
    },
    uploadFiles,
    fieldNames,
  );

  if (response['success'] == true) {
    // نقرأ invoiceId مباشرة من الرد
    int? invoiceId;
    if (response['data']?['payment']?['invoiceId'] != null) {
      invoiceId = (response['data']['payment']['invoiceId'] as num).toInt();
    } else if (response['data']?['invoiceId'] != null) {
      invoiceId = (response['data']['invoiceId'] as num).toInt();
    }

    if (invoiceId != null) {
      // الانتقال لواجهة إدخال رقم الهاتف
      Get.to(() => const PaymentPhoneScreen(), arguments: {
        'invoiceId': invoiceId,
        'amount': amount,
      });
    } else {
      Get.snackbar('الدفع', 'تم إرسال الطلب لكن لم يرجع رقم الفاتورة!',
          snackPosition: SnackPosition.TOP);
    }
  } else {
    Get.snackbar('تعذر الإرسال',
        response['message']?.toString() ?? 'حصل خطأ غير متوقع',
        backgroundColor: const Color(0xFF80C07D),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP);
  }

  isLoading.value = false;
  update();
}


  void resetForm() {
    licenceCodeController.clear();
    licenceTypeController.clear();
    amountController.clear();
    files.clear();
    licenceTypes.clear();
    update();
  }

  @override
  void onClose() {
    licenceCodeController.dispose();
    licenceTypeController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
