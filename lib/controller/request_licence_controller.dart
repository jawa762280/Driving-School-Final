import 'dart:io';

import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RequestLicenceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPageLoading = false.obs;

  TextEditingController licenceCodeController = TextEditingController();
  TextEditingController licenceTypeController = TextEditingController();
  Crud crud = Crud();
  List licenceTypes = [];
  List licenceCode = [
    {
      'type': 'private_b',
      'name': 'رخصة خصوصي ب (عادي)',
    },
    {
      'type': 'private_b1',
      'name': 'رخصة خصوصي ب1 (أوتوماتيك)',
    },
    {
      'type': 'public_c',
      'name': 'رخصة ج (عمومي)',
    },
    {
      'type': 'bus_d1',
      'name': 'رخصة د1 (باص كبير)',
    },
    {
      'type': 'truck_d2',
      'name': 'رخصة د2 (قاطرة ومقطورة)',
    },
    {
      'type': 'motor_a',
      'name': 'رخصة أ (دراجة نارية)',
    },
    {
      'type': 'construction_e',
      'name': 'رخصة أشغال (تريكسات)',
    },
  ];
  Rx<File?> file1 = Rx<File?>(null);
  Rx<File?> file2 = Rx<File?>(null);

  Future<void> pickFile(int index) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      if (index == 0) {
        file1.value = File(result.files.single.path!);
      } else if (index == 1) {
        file2.value = File(result.files.single.path!);
      }
    }
    update();
  }

  void refreshData() {
    if (licenceCodeController.text.isNotEmpty) {
      getLicences();
    } else {
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار نوع الرخصة أولاً',
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      );
    }
  }

  getLicences() async {
  isPageLoading.value = true; 
  var response = await crud.getRequest('${AppLinks.licenses}?code=${licenceCodeController.text}');
  if (response['status'] == 'success') {
    licenceTypes.clear();
    licenceTypes.addAll(response['data']);
  }
  isPageLoading.value = false;
  update();
}


  sendRequest() async {
    isLoading.value = true;

    List<XFile> files = [];
    if (file1.value != null) {
      files.add(XFile(file1.value!.path));
    }
    if (file2.value != null) {
      files.add(XFile(file2.value!.path));
    }
    List<String> strings = ['required_documents[0]', 'required_documents[1]'];
    update();
    var response = await crud.multiFileRequestMoreImagePath(
      AppLinks.licenseRequest,
      {
        'license_code': licenceCodeController.text,
        'type': licenceTypeController.text,
      },
      files,
      strings,
    );
    print(response);
    if (response['success'] == true) {
      Get.snackbar(
        'تم الإرسال',
        'تم إرسال الطلب بنجاح',
        backgroundColor: const Color(0xFF80C07D),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      );

      resetForm();
    } else if (response['success'] == false) {
      Get.snackbar(
        'تعذر الإرسال',
        response['message'].toString(),
        backgroundColor: const Color(0xFF80C07D),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      );
    }
    isLoading.value = false;

    update();
  }

  void resetForm() {
    licenceCodeController.clear();
    licenceTypeController.clear();
    file1.value = null;
    file2.value = null;
    licenceTypes.clear();
    update();
  }
}
