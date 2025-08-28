// view/screen/payment_success_screen.dart
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  String _fmtInt(int? v) => v == null ? '-' : v.toString();

  String _fmtAmount(int? v) {
    if (v == null) return '-';
    final s = v.toString();
    // تنسيق بسيط بفواصل آلاف (بدون intl)
    return s.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  Future<void> _copy(String text, {String? toast}) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (toast != null && toast.isNotEmpty) {
      Get.snackbar('نسخ', toast,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments is Map ? Get.arguments as Map : const {};
    final int? invoiceId = (args['invoiceId'] is int)
        ? args['invoiceId']
        : int.tryParse('${args['invoiceId'] ?? ''}');
    final int? amount = (args['amount'] is int)
        ? args['amount']
        : int.tryParse('${args['amount'] ?? ''}');
    final String phone = '${args['phone'] ?? ''}'; // 9639XXXXXXXX
    final String transaction = '${args['transaction'] ?? ''}'; // من confirm
    final String? operationNumber = args['operationNumber']?.toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('تأكيد الدفع'),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
        child: Column(
          children: [
            // هيدر جميل
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  // دائرة مع إشارة الصح
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE8F6EA),
                          ),
                        ),
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(Icons.check_rounded,
                              size: 42, color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'تم الدفع بنجاح',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    amount != null
                        ? 'تم تحصيل ${_fmtAmount(amount)} ل.س'
                        : 'تمت عملية الدفع',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // بطاقة تفاصيل
            Card(
              elevation: 6,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  children: [
                    _infoRow(
                      title: 'رقم الفاتورة',
                      value: _fmtInt(invoiceId),
                      icon: Icons.receipt_long,
                      onCopy: invoiceId != null
                          ? () => _copy(invoiceId.toString(),
                              toast: 'تم نسخ رقم الفاتورة')
                          : null,
                    ),
                    const Divider(height: 20),
                    _infoRow(
                      title: 'رقم العملية (Transaction)',
                      value: transaction.isEmpty ? '-' : transaction,
                      icon: Icons.verified_outlined,
                      onCopy: transaction.isNotEmpty
                          ? () =>
                              _copy(transaction, toast: 'تم نسخ رقم العملية')
                          : null,
                    ),
                    const Divider(height: 20),
                    _infoRow(
                      title: 'رقم الهاتف',
                      value: phone.isEmpty ? '-' : phone,
                      icon: Icons.phone_iphone,
                      onCopy: phone.isNotEmpty
                          ? () => _copy(phone, toast: 'تم نسخ رقم الهاتف')
                          : null,
                    ),
                    if (operationNumber != null) ...[
                      const Divider(height: 20),
                      _infoRow(
                        title: 'Operation Number',
                        value: operationNumber,
                        icon: Icons.tag_outlined,
                        onCopy: () => _copy(operationNumber,
                            toast: 'تم نسخ Operation Number'),
                      ),
                    ],
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // زر واحد: تم (Primary)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.offAllNamed(AppRouts.studentHomePageScreen);
                },
                icon:
                    const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text(
                  'تم',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required String title,
    required String value,
    required IconData icon,
    VoidCallback? onCopy,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  )),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
        if (onCopy != null)
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'نسخ',
            onPressed: onCopy,
          ),
      ],
    );
  }
}
