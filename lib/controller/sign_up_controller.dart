import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/core/constant/message_service.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class SignUpController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Crud crud = Crud();
  var isLoading = false.obs;
  bool isShowPass = true;
  File? imageFile;
  String? emailError;
  String? phoneError;
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  late TextEditingController passController;
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  late TextEditingController birthDateController;
  late TextEditingController genderController;
  late TextEditingController imageController;

  showPass() {
    isShowPass = !isShowPass;
    update();
  }

  signUp() async {
    // التحقق من صحة الفورم
    if (!formState.currentState!.validate()) return;

    // التحقق من وجود صورة

    // التحقق من اكتمال البيانات
    if (roleController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      Get.snackbar("خطأ", "الرجاء تعبئة جميع الحقول");
      return;
    }

    isLoading.value = true;
    update();

    try {
      // تجهيز البيانات
      Map<String, String> data = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'password': passController.text,
        'date_of_Birth': birthDateController.text,
        'gender': genderController.text.toLowerCase(),
        'phone_number': phoneController.text,
        'address': addressController.text,
        'role': roleController.text.toLowerCase(),
      };
      String selectedRole = roleController.text.toLowerCase();
      String apiUrl = selectedRole == "trainer"
          ? AppLinks.signUpTrainer
          : AppLinks.signUpStudent;
      // إرسال الطلب
      var response = await crud.fileRequestPOST(apiUrl, data, imageFile);
      isLoading.value = false;
      // معالجة الرد
      if (response == null) {
        Get.snackbar("خطأ", "لا يوجد رد من الخادم");
        return;
      }
      // ignore: avoid_print
      print(response);
      // حالة النجاح
      if (response['status'] == "success") {
        MessageService.showSnackbar(
            title: "نجاح", message: response['message']);
        Get.toNamed(AppRouts.verifyCodeSignUpScreen, arguments: {
          "email": response['data']['email'],
          "user_id": response['data']['user_id'],
        });
      }
      // حالة وجود أخطاء (422)
      else if (response['errors'] != null) {
        // مسح الأخطاء السابقة
        emailError = null;
        phoneError = null;

        // تجميع رسائل الخطأ
        if (response['errors']['email'] != null) {
          emailError = response['errors']['email'][0];
        }
        if (response['errors']['phone_number'] != null) {
          phoneError = response['errors']['phone_number'][0];
        }

        // عرض رسالة الخطأ الرئيسية مع التفاصيل
        MessageService.showSnackbar(
          title: "خطأ في التسجيل",
          message: response['message'] ?? "بيانات غير صالحة",
        );

        update(); // لتحديث حالة الحقول في الواجهة
      }
      // حالات أخرى
      else {
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
    passController = TextEditingController();
    emailController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    birthDateController = TextEditingController();
    genderController = TextEditingController();
    imageController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    passController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    genderController.dispose();
    imageController.dispose();
    super.onClose();
  }
}
