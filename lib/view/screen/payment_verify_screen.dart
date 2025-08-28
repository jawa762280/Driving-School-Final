// view/screen/payment_verify_screen.dart
import 'package:driving_school/controller/payment_verify_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PaymentVerifyScreen extends StatelessWidget {
  const PaymentVerifyScreen({super.key});

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("التحقق من الكود"),
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<PaymentVerifyController>()
        ? Get.find<PaymentVerifyController>()
        : Get.put(PaymentVerifyController());

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أدخل رمز التحقق',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Obx(() => Text(
                  c.maskedPhone.value.isEmpty
                      ? 'قمنا بإرسال الرمز إلى رقم هاتفك'
                      : 'قمنا بإرسال الرمز إلى ${c.maskedPhone.value}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                )),
            const SizedBox(height: 22),

            // رسمة القفل
            Center(
              child: SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEBFF),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(Icons.lock_outline,
                          color: Colors.white, size: 30),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: TextField(
                      controller: c.codeCtrl,
                      onChanged: c.onCodeChanged,
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => c.submit(),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                        hintText: 'أدخل الكود (6 أرقام)',
                        hintTextDirection: TextDirection.ltr,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                              color: AppColors.primaryColor, width: 1.6),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Obx(() => SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: c.isValid.value && !c.isLoading.value
                            ? c.submit
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          disabledBackgroundColor:
                              AppColors.primaryColor.withOpacity(.35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: c.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('تحقق',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                )),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
