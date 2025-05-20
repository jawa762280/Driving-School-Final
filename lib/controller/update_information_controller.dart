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
    if (!formState.currentState!.validate()) return;

    isLoading.value = true;
    update();

    try {
      if (data.read('user')['student_id'].toString() == 'null' ||
          data.read('user')['student_id'].toString().isEmpty) {
        Get.snackbar("خطأ", "معرف المستخدم غير متوفر");
        isLoading.value = false;
        return;
      }

      Map<String, String> datas = {
        '_mthod': 'PUT',
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'date_of_Birth': birthDateController.text,
        'phone_number': phoneController.text,
        'address': addressController.text,
        'role': data.read('role').toString(),
        'gender': genderController.text,
      };

      var response = await crud.fileRequest(
        '${AppLinks.updateInformation}/${data.read('user')['student_id']}',
        datas,
        imageFile,
      );
      print('MyData $datas');
      isLoading.value = false;

      if (response == null) {
        Get.snackbar("خطأ", "لا يوجد رد من الخادم");
        return;
      }

      if (response['status'] == "success") {
        print('MyDataOnlu ${response['data']}');
        MessageService.showSnackbar(
          title: "نجاح",
          message: response['message'],
        );

        // لو غير الصورة، حدثها محليًا
        if (imageFile != null) {
          if (response['data'] != null && response['data']['image'] != null) {
            String rawImage = response['data']['image'];
            String cleanImage = sanitizeImageUrl(rawImage);
            data.remove('user');
            data.write('user', response['data']);
            imageUrl = cleanImage;
          }
        }
        Get.offAllNamed(AppRouts.studentHomePageScreen);
        update();
      } else if (response['errors'] != null) {
        phoneError = null;
        if (response['errors']['phone_number'] != null) {
          phoneError = response['errors']['phone_number'][0];
        }
        MessageService.showSnackbar(
          title: "خطأ في التسجيل",
          message: response['message'] ?? "بيانات غير صالحة",
        );
        update();
      } else {
        MessageService.showSnackbar(
          title: "خطأ",
          message: response['message'] ?? "حدث خطأ غير متوقع",
        );
      }
    } catch (e) {
      isLoading.value = false;
      MessageService.showSnackbar(
        title: "خطأ",
        message: "حدث خطأ أثناء الاتصال: ${e.toString()}",
      );
    }
  }

  @override
  void onInit() {
    print(data.read('user'));
    firstNameController.text = data.read('user')['first_name'] ?? '';
    lastNameController.text = data.read('user')['last_name'] ?? '';
    birthDateController.text = data.read('user')['date_of_Birth'] ?? '';
    genderController.text =
        (data.read('user')['gender'] ?? '').toString().capitalize!;
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
