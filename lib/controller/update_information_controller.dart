import 'dart:io';

import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/core/constant/message_service.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateInformationController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Crud crud = Crud();
  String? imageUrl;
  var isLoading = false.obs;
  bool isShowPass = true;
  File? imageFile;
  String? phoneError;
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController passController = TextEditingController();
  late TextEditingController firstNameController = TextEditingController();
  late TextEditingController lastNameController = TextEditingController();
  late TextEditingController birthDateController = TextEditingController();
  late TextEditingController genderController = TextEditingController();
  late TextEditingController imageController = TextEditingController();

  void showPass() {
    isShowPass = !isShowPass;
    update();
  }

  String sanitizeImageUrl(String rawUrl) {
    final regex = RegExp(r'(http:\/\/[^\s]+\/images\/[^\s]+)');
    final match = regex.firstMatch(rawUrl);
    if (match != null) {
      return match.group(0)!;
    }
    return rawUrl; // fallback
  }

  updateInformation() async {
    isLoading.value = true;
    update();
    var response = await crud.fileRequest(
      '${AppLinks.updateInformation}/${data.read('user')['student_id']}',
      {
        '_method': 'PUT',
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'date_of_Birth': birthDateController.text,
        data.read('user')['phone_number'].toString() == phoneController.text
            ? ''
            : 'phone_number': phoneController.text,
        'address': addressController.text,
        'role': data.read('role').toString(),
        'gender': genderController.text,
      },
      imageFile,
    );
    isLoading.value = false;
    update();
    if (response['status'] == 'success') {
      data.remove('user');
      data.write('user', response['data']);
      MessageService.showSnackbar(
        title: "نجاح",
        message: response['message'],
      );
      Get.offAllNamed(AppRouts.studentHomePageScreen);
    }
  }

  @override
  void onInit() {
    print(data.read('user'));
    print('REFRESHTOKEN ${data.read('refreshToken')}');
    firstNameController.text = data.read('user')['first_name'] ?? '';
    lastNameController.text = data.read('user')['last_name'] ?? '';
    birthDateController.text = data.read('user')['date_of_Birth'] ?? '';
    genderController.text = data.read('user')['gender'].toString();
    phoneController.text = data.read('user')['phone_number'] ?? '';
    roleController.text = data.read('role') ?? '';
    addressController.text = data.read('user')['address'] ?? '';
    imageUrl =
        'http${data.read('user')['image'].toString().split('http').last}';

    update();
    super.onInit();
  }

  @override
  void onClose() {
    passController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    genderController.dispose();
    imageController.dispose();
    phoneController.dispose();
    roleController.dispose();
    super.onClose();
  }
}
