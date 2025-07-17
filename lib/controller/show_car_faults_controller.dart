import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';

class ShowCarFaultsController extends GetxController {
  final Crud _crud = Crud();
  var isLoading = false.obs;
  var faults = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaults();
  }

  Future<void> fetchFaults() async {
    try {
      isLoading(true);
      final resp = await _crud.getRequest(AppLinks.carFaults);

      if (resp != null && resp['data'] is List) {
        faults.value = (resp['data'] as List)
            .cast<Map<String, dynamic>>();
      } else {
        faults.clear();
        Get.snackbar(
          'تنبيه',
          'لا توجد أعطال أو صيغ البيانات غير صحيحة',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر جلب الأعطال، حاول مرة أخرى لاحقًا',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
