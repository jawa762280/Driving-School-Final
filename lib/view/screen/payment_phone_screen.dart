// view/screen/payment_phone_screen.dart
import 'package:driving_school/controller/payment_phone_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PaymentPhoneScreen extends StatelessWidget {
  const PaymentPhoneScreen({super.key});

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('الدفع'),
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,  
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<PaymentPhoneController>()
        ? Get.find<PaymentPhoneController>()
        : Get.put(PaymentPhoneController());

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أدخل رقم الهاتف',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Obx(() {
              final amt = c.amountSyp.value;
              final subtitle = amt > 0
                  ? 'ادفع إلى MTN Cash  ${amt.toString()}  ل.س'
                  : 'ادفع إلى MTN Cash';
              return Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              );
            }),

            const SizedBox(height: 22),

            // دائرة و أيقونة
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150, height: 150,
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
                      width: 70, height: 110,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(Icons.smartphone,
                          color: Colors.white, size: 36),
                    ),
                    _dot(const Offset(-70, -30), 10, Colors.teal),
                    _dot(const Offset(78, -10), 14, Colors.pinkAccent),
                    _dot(const Offset(-84, 35), 12, Colors.orangeAccent),
                    _dot(const Offset(76, 50), 10, Colors.blueAccent),
                    _dot(const Offset(-10, -80), 8, Colors.green),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // حقل رقم الهاتف
            SizedBox(
              height: 54,
              child: TextField(
                controller: c.phoneCtrl,
                onChanged: c.onPhoneChanged,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => c.submit(),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12), // 09XXXXXXXX أو 9639XXXXXXXX
                ],
                decoration: InputDecoration(
                  hintText: 'رقم الهاتف (09XXXXXXXX أو 9639XXXXXXXX)',
                  hintTextDirection: TextDirection.ltr,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                    borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 1.6),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // زر الدفع
            Obx(() => SizedBox(
                  height: 56, width: double.infinity,
                  child: ElevatedButton(
                    onPressed: c.isValid.value && !c.isLoading.value
                        ? c.submit
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      disabledBackgroundColor:
                          AppColors.primaryColor.withOpacity(.35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: c.isLoading.value
                        ? const SizedBox(
                            height: 22, width: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('ادفع',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

Widget _dot(Offset o, double r, Color c) => Positioned(
      left: 100 + o.dx,
      top: 100 + o.dy,
      child: Container(
        width: r, height: r,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      ),
    );
