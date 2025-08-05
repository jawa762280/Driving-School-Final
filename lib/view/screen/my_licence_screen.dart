import 'package:driving_school/controller/my_licenses_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyLicenceScreen extends StatelessWidget {
  const MyLicenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: MyLicensesController(),
        builder: (controller) {
          final pendingLicenses = controller.myLicenses
              .where((e) => e['status'] == 'pending')
              .toList();
          final approvedLicenses = controller.myLicenses
              .where((e) => e['status'] == 'approved')
              .toList();

          return Scaffold(
            backgroundColor: const Color(0xFFF2F4F8),
            appBar: AppBar(
              title: const Text(
                "رخصاتي",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: AppColors.primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 2,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  tooltip: 'تحديث',
                  onPressed: () {
                    controller.getMyLicense();
                  },
                ),
              ],
            ),
            body: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                children: [
                  if (pendingLicenses.isNotEmpty) ...[
                    _buildSectionTitle("📝 الرخص قيد الانتظار"),
                    const SizedBox(height: 12),
                    for (var license in pendingLicenses)
                      _buildFancyCard(license, Colors.orange),
                  ],
                  if (approvedLicenses.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _buildSectionTitle("✅ الرخص المعتمدة"),
                    const SizedBox(height: 12),
                    for (var license in approvedLicenses)
                      _buildFancyCard(license, Colors.green),
                  ],
                  if (pendingLicenses.isEmpty && approvedLicenses.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.hourglass_empty,
                                size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              "لا توجد بيانات حالياً",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "لم تقم بأي طلب رخصة حتى الآن",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }),
          );
        });
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333740),
      ),
    );
  }

  Widget _buildFancyCard(Map license, Color statusColor) {
    final String name = license['license']['name'] ?? 'غير معروف';
    final String status = _getStatusText(license['status']);
    final String type = _getTypeText(license['type']);
    final String date = _formatDate(license['created_at']);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).toInt()),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: statusColor.withAlpha((0.15 * 255).toInt()),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.card_membership,
                color: statusColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline,
                              color: statusColor, size: 16),
                          SizedBox(width: 4),
                          Text(status, style: TextStyle(color: statusColor)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.repeat, color: Colors.grey, size: 16),
                          SizedBox(width: 4),
                          Text(type, style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.date_range,
                          color: Colors.blueGrey, size: 16),
                      const SizedBox(width: 4),
                      Text(date, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.grey),
              onPressed: () {
                Get.toNamed(AppRouts.licenseDetails, arguments: license);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'approved':
        return 'معتمدة';
      case 'rejected':
        return 'مرفوضة';
      default:
        return status;
    }
  }

  String _getTypeText(String type) {
    switch (type) {
      case 'new':
        return 'طلب جديد';
      case 'renew':
        return 'تجديد';
      default:
        return type;
    }
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy', 'ar').format(dateTime);
    } catch (e) {
      return '-';
    }
  }
}
