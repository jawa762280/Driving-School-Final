// controller/payment_phone_controller.dart
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentPhoneController extends GetxController {
  final TextEditingController phoneCtrl = TextEditingController();
  final isValid = false.obs;
  final isLoading = false.obs;

  final amountSyp = 0.obs;   // للعرض فقط
  final invoiceId = 0.obs;   // مهم للإرسال

  final Crud _crud = Crud();

  // يقبل 09XXXXXXXX أو 9639XXXXXXXX
  void onPhoneChanged(String v) {
    final t = v.replaceAll(RegExp(r'[^0-9]'), '');
    isValid.value =
        (t.length == 10 && t.startsWith('09')) ||
        (t.length == 12 && t.startsWith('9639'));
  }

  // للـ API: إن أدخل 09XXXXXXXX نحولها إلى 9639XXXXXXXX
  String formatPhoneForApi(String input) {
    final t = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (t.startsWith('09') && t.length == 10) {
      return '963${t.substring(1)}';
    }
    return t; // 9639XXXXXXXX
  }

  String maskPhone(String e164) {
    if (e164.length < 12) return e164;
    return '${e164.substring(0, 4)}****${e164.substring(8)}';
  }

  Future<void> submit() async {
    if (!isValid.value || isLoading.value) return;
    if (invoiceId.value <= 0) {
      Get.snackbar('الدفع', 'لا يوجد رقم فاتورة invoiceId',
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading.value = true;
    try {
      final formattedPhone = formatPhoneForApi(phoneCtrl.text.trim());

      // initiate
      final res = await _crud.postRequest(
        AppLinks.mtnFlowInitiate,
        {
          "invoiceId": invoiceId.value,
          "phone": formattedPhone,
        },
      );

      // الريسبونس بحسب ما أرسلت:
      // { "invoiceId": ..., "guid": "...",
      //   "apiResponse": { "status": 200, "json": { "Errno": 0, "OperationNumber": ... } } }
      final status = res['apiResponse']?['status'];
      final errno  = res['apiResponse']?['json']?['Errno'];
      final guid   = res['guid'];
      final opNum  = res['apiResponse']?['json']?['OperationNumber'];

      if (status == 200 && errno == 0 && guid is String && guid.isNotEmpty) {
        final masked = maskPhone(formattedPhone);

        Get.toNamed(AppRouts.paymentVerifyScreen, arguments: {
          'invoiceId': invoiceId.value,
          'guid': guid,
          'phone': formattedPhone,      // 9639XXXXXXXX
          'maskedPhone': masked,
          'amount': amountSyp.value,
          'operationNumber': opNum,     // مطلوب في confirm
        });
      } else {
        final msg = res['apiResponse']?['json']?['ReceiptError']?['Msg'] ??
            res['message'] ?? 'تعذر بدء عملية الدفع';
        Get.snackbar('الدفع', msg.toString(),
            backgroundColor: Colors.red.shade400, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('الدفع', 'تعذّر الاتصال بالخادم',
          backgroundColor: Colors.red.shade400, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // نتوقع المرور هكذا:
    // Get.to(() => const PaymentPhoneScreen(), arguments: {'invoiceId': 1756..., 'amount': 30000})
    final args = Get.arguments;
    if (args is Map) {
      final inv = args['invoiceId'];
      final amt = args['amount'];
      if (inv is int) invoiceId.value = inv;
      if (inv is String) invoiceId.value = int.tryParse(inv) ?? 0;
      if (amt is int) amountSyp.value = amt;
      if (amt is String) amountSyp.value = int.tryParse(amt) ?? 0;
    }
    super.onInit();
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    super.onClose();
  }
}
