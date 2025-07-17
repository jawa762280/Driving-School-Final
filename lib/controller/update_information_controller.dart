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
  bool isLeftHandDisabled = false;
  bool isMilitary = false;
  TextEditingController nationalityController = TextEditingController();

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
    return rawUrl;
  }

  updateInformation() async {
    Map<String, String> datas = {
      '_method': 'PUT',
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'date_of_Birth': birthDateController.text,
      'address': addressController.text,
      'role': data.read('role').toString(),
      'gender': genderController.text,
    };

    experience.text !=
            data
                .read('user')[data.read('role').toString()]['experience']
                .toString()
        ? datas.addAll({
            'experience': experience.text,
          })
        : null;
    licenseNumber.text !=
            data
                .read('user')[data.read('role').toString()]['license_number']
                .toString()
        ? datas.addAll({
            'license_number': licenseNumber.text,
          })
        : null;
    phoneController.text ==
            data
                .read('user')[data.read('role').toString()]['phone_number']
                .toString()
        ? null
        : datas.addAll({
            'phone_number': phoneController.text,
          });
    password.text.isNotEmpty
        ? datas.addAll({
            'password': password.text,
          })
        : null;
    data.read('role').toString() == 'trainer'
        ? datas.addAll({
            'license_expiry_date': licenseExpiryDate.text,
            'training_type': trainingType.text,
          })
        : null;
    data.read('role').toString() == 'student'
        ? datas.addAll({
            'is_military': isMilitary ? '1' : '0',
            'left_hand_disabled': isLeftHandDisabled ? '1' : '0',
            'nationality': nationalityController.text,
          })
        : null;
    String apiLink = data.read('role').toString() == 'trainer'
        ? '${AppLinks.trainers}/${data.read('user')[data.read('role').toString()]['id']}'
        : '${AppLinks.updateInformation}/${data.read('user')[data.read('role').toString()]['id']}';
    isLoading.value = true;
    update();
    var response = await crud.fileRequest(apiLink, datas, imageFile, 'image');
    isLoading.value = false;
    update();
    if (response['status'] == 'success') {
      data.remove('user');
      data.write('user', response['data']['user']);
      MessageService.showSnackbar(
        title: "نجاح",
        message: response['message'],
      );
      data.read('role').toString() == 'student'
          ? Get.offAllNamed(AppRouts.studentHomePageScreen)
          : Get.offAllNamed(AppRouts.trainerHomePageScreen);
    }
  }

  @override
  void onInit() {
    // ignore: avoid_print
    print(data.read('user'));
    // ignore: avoid_print
    print('REFRESHTOKEN ${data.read('refreshToken')}');
    email.text = data.read('user')['email'] ?? '';
    firstNameController.text =
        data.read('user')[data.read('role').toString()]['first_name'] ?? '';
    lastNameController.text =
        data.read('user')[data.read('role').toString()]['last_name'] ?? '';
    birthDateController.text =
        data.read('user')[data.read('role').toString()]['date_of_Birth'] ?? '';
    genderController.text =
        data.read('user')[data.read('role').toString()]['gender'].toString();
    phoneController.text =
        data.read('user')[data.read('role').toString()]['phone_number'] ?? '';
    roleController.text = data.read('role') ?? '';
    addressController.text =
        data.read('user')[data.read('role').toString()]['address'] ?? '';
    licenseNumber.text =
        data.read('user')[data.read('role').toString()]['license_number'] ?? '';
    licenseExpiryDate.text = data.read('user')[data.read('role').toString()]
            ['license_expiry_date'] ??
        '';
    trainingType.text =
        data.read('user')[data.read('role').toString()]['training_type'] ?? '';
    experience.text =
        data.read('user')[data.read('role').toString()]['experience'] ?? '';
    /////////////////////
    nationalityController.text =
        data.read('user')[data.read('role').toString()]['nationality'] ?? '';
    data.read('user')[data.read('role').toString()]['is_military'].toString() ==
            '0'
        ? isMilitary = false
        : isMilitary = true;
    data
                .read('user')[data.read('role').toString()]
                    ['left_hand_disabled']
                .toString() ==
            '0'
        ? isLeftHandDisabled = false
        : isLeftHandDisabled = true;
    //////////////////
    imageUrl =
        'http${data.read('user')[data.read('role').toString()]['image'].toString().split('http').last}';

    update();
    super.onInit();
  }
}
