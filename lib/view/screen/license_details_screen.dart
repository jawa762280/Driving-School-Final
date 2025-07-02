import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constant/appcolors.dart';

class LicenseDetailsScreen extends StatelessWidget {
  const LicenseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map license = Get.arguments;
    final List documents = license['document_files'] ?? [];

    final String name = license['license']['name'] ?? 'غير معروف';
    final String status = _getStatusText(license['status']);
    final String type = _getTypeText(license['type']);
    final String createdAt = _formatDate(license['created_at']);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("تفاصيل الرخصة", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle("📄 معلومات الرخصة"),
          const SizedBox(height: 12),
          _buildInfoCard([
            _InfoItem(Icons.card_membership, "اسم الرخصة", name),
            _InfoItem(Icons.info_outline, "الحالة", status, statusColor: _getStatusColor(license['status'])),
            _InfoItem(Icons.loop, "نوع الطلب", type),
            _InfoItem(Icons.calendar_today, "تاريخ التقديم", createdAt),
          ]),
          const SizedBox(height: 28),
          _buildSectionTitle("📎 الملفات المرفقة"),
          const SizedBox(height: 12),
          documents.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text("لا توجد ملفات", style: TextStyle(color: Colors.grey)),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final doc = documents[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GestureDetector(
                        onTap: () {
                          _showFullImage(context, doc['url']);
                        },
                        child: Image.network(
                          doc['url'],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333740),
      ),
    );
  }

  Widget _buildInfoCard(List<_InfoItem> items) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Icon(item.icon, color: item.statusColor ?? AppColors.primaryColor),
                    const SizedBox(width: 12),
                    Text(
                      "${item.label}: ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        item.value,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: item.statusColor ?? Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _showFullImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: InteractiveViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              url,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.broken_image, size: 60, color: Colors.white)),
            ),
          ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return AppColors.primaryColor;
    }
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final Color? statusColor;

  _InfoItem(this.icon, this.label, this.value, {this.statusColor});
}
