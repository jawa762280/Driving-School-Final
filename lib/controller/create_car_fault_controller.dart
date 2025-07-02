import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/data/model/car_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateCarFaultController extends GetxController {
  Crud crud = Crud();
  var cars = <CarModel>[].obs;
  RxBool isLoading = false.obs;
  TextEditingController faultController = TextEditingController();

  getCars() async {
    var response = await crud.getRequest(AppLinks.cars);
    if (response != null && response['status'] == 'success') {
      cars.value = (response['data'] as List)
          .map((json) => CarModel.fromJson(json))
          .toList();
    }
    update();
  }

  sendFault(id) async {
    isLoading.value = true;
    var response = await crud.postRequest(AppLinks.addFault, {
      'car_id': id,
      'comment': faultController.text,
    });
    isLoading.value = false;
    if (response['status'] == true) {
      faultController.clear();
      Navigator.pop(Get.context!);
      Get.snackbar(
        'تم الإرسال',
        'تم إرسال العطل بنجاح',
        backgroundColor: const Color(0xFF80C07D),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        'خطأ',
        'فشل في إرسال العطل',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      );
    }
    update();
  }

  @override
  void onInit() {
    getCars();
    super.onInit();
  }
}
