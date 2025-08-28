// controller/payment_verify_controller.dart (المقاطع المهمة فقط)
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/view/screen/payment_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentVerifyController extends GetxController {
  final TextEditingController codeCtrl = TextEditingController();
  final isValid = false.obs;
  final isLoading = false.obs;

  final maskedPhone = ''.obs;

  final Crud _crud = Crud();

  late int invoiceId;
  late String phone;            // 9639XXXXXXXX
  late String guid;
  int? operationNumber;         // من initiate
  int? amount;                  // للعرض في شاشة النجاح

  void onCodeChanged(String v) => isValid.value = v.trim().length >= 4;

  Future<void> submit() async {
    final otp = codeCtrl.text.trim();
    if (!isValid.value || isLoading.value) return;

    isLoading.value = true;
    try {
      final res = await _crud.postRequest(
        AppLinks.mtnFlowConfirm,
        {
          "invoiceId": invoiceId,
          "phone": phone,
          "guid": guid,
          "operationNumber": operationNumber,
          "otp": int.tryParse(otp) ?? otp,
        },
      );

      // نجاح (مثل ما وصلّك): Errno = 0
      final status = res['apiResponse']?['status'];
      final errno  = res['apiResponse']?['json']?['Errno'];
      final tx     = res['apiResponse']?['json']?['Transaction']?.toString() ?? '';

      if (status == 200 && errno == 0) {
        // انتقل لواجهة النجاح مع التفاصيل
        Get.off(() => const PaymentSuccessScreen(), arguments: {
          'invoiceId': invoiceId,
          'amount': amount,
          'phone': phone,
          'operationNumber': operationNumber,
          'transaction': tx,
        });
      } else {
        final msg = res['apiResponse']?['json']?['Error'] ??
            res['message'] ?? 'لم يتم تأكيد الدفع';
        Get.snackbar('الدفع', msg.toString(),
            backgroundColor: Colors.red.shade400, colorText: Colors.white);
      }
    } catch (_) {
      Get.snackbar('الدفع', 'تعذّر تأكيد العملية',
          backgroundColor: Colors.red.shade400, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is Map) {
      invoiceId = args['invoiceId'] is int
          ? args['invoiceId']
          : int.tryParse('${args['invoiceId']}') ?? 0;
      phone = '${args['phone'] ?? ''}';
      guid = '${args['guid'] ?? ''}';
      maskedPhone.value = '${args['maskedPhone'] ?? ''}';
      if (args['operationNumber'] != null) {
        operationNumber = args['operationNumber'] is int
            ? args['operationNumber']
            : int.tryParse('${args['operationNumber']}');
      }
      if (args['amount'] != null) {
        amount = args['amount'] is int
            ? args['amount']
            : int.tryParse('${args['amount']}');
      }
    } else {
      invoiceId = 0;
      phone = '';
      guid = '';
      operationNumber = null;
      amount = null;
    }
    super.onInit();
  }

  @override
  void onClose() {
    codeCtrl.dispose();
    super.onClose();
  }
}
