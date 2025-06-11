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
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController licenseNumber = TextEditingController();
  TextEditingController licenseExpiryDate = TextEditingController();
  TextEditingController trainingType = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  late Map<String, dynamic> originalUserData;

  void showPass() {
    isShowPass = !isShowPass;
    update();
  }

  updateInformation() async {
    Map<String, String> datas = {
      '_method': 'PUT',
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'date_of_Birth': birthDateController.text,
      'phone_number': phoneController.text,
      'address': addressController.text,
      'role': roleController.text,
      'gender': genderController.text,
    };

    if (password.text.isNotEmpty) {
      datas['password'] = password.text;
    }

    if (roleController.text == 'trainer') {
      datas.addAll({
        'license_number': licenseNumber.text,
        'license_expiry_date': licenseExpiryDate.text,
        'training_type': trainingType.text,
        'experience': experience.text,
      });
    }

    // إذا حابب تعمل مقارنة للقيم القديمة والجديدة قبل الإرسال لتفادي إرسال بيانات غير متغيرة
    datas.removeWhere((key, value) {
      if (key == '_method') return false; // أبقي هذا المفتاح ضروري
      // قارن مع البيانات الأصلية المخزنة
      if (originalUserData.containsKey(key)) {
        var originalValue = originalUserData[key];
        // بعض الحقول مثل role، ممكن تكون ليست في originalUserData مباشرة
        if (originalValue == null && value.isEmpty) return true;
        return originalValue.toString() == value;
      }
      return false;
    });

    if (datas.length <= 1) {
      // يعني ما في تغييرات سوى _method فقط
      MessageService.showSnackbar(
        title: "تنبيه",
        message: "لم تقم بتعديل أي بيانات",
      );
      return;
    }

    String apiLink = roleController.text == 'trainer'
        ? '${AppLinks.trainers}/${originalUserData['id']}'
        : '${AppLinks.updateInformation}/${originalUserData['id']}';

    isLoading.value = true;
    update();

    var response = await crud.fileRequest(
      apiLink,
      datas,
      imageFile,
    );

    isLoading.value = false;
    update();

    if (response != null && response['status'] == 'success') {
      data.write('user', response['data']);
      data.write('role', roleController.text);
      MessageService.showSnackbar(
        title: "نجاح",
        message: response['message'],
      );
      if (roleController.text == 'student') {
        Get.offAllNamed(AppRouts.studentHomePageScreen);
      } else if (roleController.text == 'trainer') {
        Get.offAllNamed(AppRouts.trainerHomePageScreen);
      }
    } else {
      // معالجة الأخطاء (مثلاً عرض رسالة)
      MessageService.showSnackbar(
        title: "خطأ",
        message: response?['message'] ?? 'حدث خطأ غير معروف',
      );
    }
  }

  @override
  void onInit() {
    super.onInit();

    final role = data.read('role');
    final user = data.read('user');

    if (user == null || role == null) {
      print("User data or role is null!");
      return;
    }

    originalUserData = Map<String, dynamic>.from(user);

    email.text = user['email'] ?? '';
    firstNameController.text = user['first_name'] ?? '';
    lastNameController.text = user['last_name'] ?? '';
    birthDateController.text = user['date_of_Birth'] ?? '';
    genderController.text = user['gender']?.toString() ?? '';
    phoneController.text = user['phone_number'] ?? '';
    roleController.text = role;
    addressController.text = user['address'] ?? '';
    licenseNumber.text = user['license_number'] ?? '';
    licenseExpiryDate.text = user['license_expiry_date'] ?? '';
    trainingType.text = user['training_type'] ?? '';
    experience.text = user['experience'] ?? '';

    final rawImage = user['image']?.toString() ?? '';
    if (rawImage.startsWith('http')) {
      imageUrl = rawImage;
    } else if (rawImage.isNotEmpty) {
      imageUrl = 'http${rawImage.split('http').last}';
    } else {
      imageUrl = ''; // صورة فارغة أو صورة افتراضية
    }

    update();
  }
}
