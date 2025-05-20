import 'dart:io';

import 'package:driving_school/controller/user_controller.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/core/constant/message_service.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
    final role = data.read('userRole');

    if (role != 'student') {
      Get.snackbar("خطأ", "لا يمكن تحديث بيانات غير الطالب من هذه الشاشة.");
      return;
    }

    final studentId = data.read('student_id');

    try {
      final storage = GetStorage();

      Map<String, String> data = {};

      // دالة لإضافة الحقول التي تغيرت فقط
      void addIfChanged(String key, TextEditingController controller,
          {String? storageKey, bool toLower = false}) {
        String? oldValue =
            (storage.read(storageKey ?? key) ?? '').toString().trim();
        String newValue = controller.text.trim();

        if (toLower) {
          oldValue = oldValue.toLowerCase();
          newValue = newValue.toLowerCase();
        }

        if (newValue.isNotEmpty && newValue != oldValue) {
          data[key] = newValue;
        }
      }

      addIfChanged('first_name', firstNameController, storageKey: 'firstName');
      addIfChanged('last_name', lastNameController, storageKey: 'lastName');
      addIfChanged('date_of_Birth', birthDateController,
          storageKey: 'dateOfBirth');
      addIfChanged('gender', genderController,
          storageKey: 'gender', toLower: true);
      addIfChanged('phone_number', phoneController, storageKey: 'phone_number');
      addIfChanged('address', addressController, storageKey: 'address');

      print('Data to be sent: $data');

      if (data.isEmpty && imageFile == null) {
        Get.snackbar("تنبيه", "لم تقم بتغيير أي بيانات");
        isLoading.value = false;
        return;
      }

      if (studentId == null || studentId.isEmpty) {
        Get.snackbar("خطأ", "معرف المستخدم غير متوفر");
        isLoading.value = false;
        return;
      }

      // ✅ استدعاء دالة putFileRequest الجديدة
      var response = await crud.putFileRequest(
        '${AppLinks.updateInformation}/$studentId',
        data,
        imageFile,
      );

      isLoading.value = false;

      if (response == null) {
        Get.snackbar("خطأ", "لا يوجد رد من الخادم");
        return;
      }

      if (response['status'] == "success") {
        MessageService.showSnackbar(
          title: "نجاح",
          message: response['message'],
        );

        // تحديث التخزين المحلي فقط للحقول التي تم تعديلها
        data.forEach((key, value) {
          if (key != 'method') {
            String storageKey;
            switch (key) {
              case 'first_name':
                storageKey = 'firstName';
                break;
              case 'last_name':
                storageKey = 'lastName';
                break;
              case 'date_of_Birth':
                storageKey = 'dateOfBirth';
                break;
              case 'phone_number':
                storageKey = 'phone_number';
                break;
              case 'address':
                storageKey = 'address';
                break;
              case 'gender':
                storageKey = 'gender';
                break;
              default:
                storageKey = key;
            }
            storage.write(storageKey, value);
          }
        });
        final userController = Get.find<UserController>();
        userController.loadUserFromStorage();
        // لو غير الصورة، حدثها محليًا
        if (imageFile != null) {
          if (response['data'] != null && response['data']['image'] != null) {
            String rawImage = response['data']['image'];
            String cleanImage = sanitizeImageUrl(rawImage);
            storage.write('userImage', cleanImage);
            imageUrl = cleanImage;
          }
        }

        Get.offNamed(AppRouts.studentHomePageScreen);
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
    addressController = TextEditingController();
    passController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    birthDateController = TextEditingController();
    genderController = TextEditingController();
    imageController = TextEditingController();
    phoneController = TextEditingController();

    final storage = GetStorage();
    print('📦 البيانات من التخزين:');
    print('First Name: ${storage.read('firstName')}');
    print('Address: ${storage.read('address')}');
    print('Phone: ${storage.read('phone_number')}');
    firstNameController.text = storage.read('firstName') ?? '';
    lastNameController.text = storage.read('lastName') ?? '';
    birthDateController.text = storage.read('dateOfBirth') ?? '';
    genderController.text =
        (storage.read('gender') ?? '').toString().capitalize!;
    phoneController.text = storage.read('phone_number') ?? '';
    roleController.text = storage.read('userRole') ?? '';
    addressController.text = storage.read('address') ?? '';
    imageUrl = storage.read('userImage');

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
