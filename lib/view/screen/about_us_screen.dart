import 'package:flutter/material.dart';
import 'package:driving_school/core/constant/appimages.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'معلومات عنا',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 4,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Logo with animated scale & fade
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 900),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value.clamp(
                      0.0, 1.0), // للتأكد من أن القيمة ضمن النطاق المسموح
                  child: child,
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    AppImages.logo,
                    width: 160,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'أهلاً بكم في تطبيق "مدرسة قيادة"، منصتكم الشاملة لتعلم القيادة بأمان واحتراف. '
              'صممنا هذا التطبيق خصيصاً لنجعل رحلتكم نحو رخصة القيادة أكثر مرونة وسلاسة، بخدمات متكاملة وتقنيات ذكية تلبي تطلعاتكم.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                height: 1.8,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 28),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '🌟 أبرز مميزاتنا',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildFeatureCard(Icons.credit_card, 'إصدار الرخص',
                'متابعة جميع الإجراءات الرسمية لاستخراج الرخصة بسهولة.'),
            _buildFeatureCard(Icons.directions_car, 'تدريب عملي متقدم',
                'دروس قيادة ميدانية باستخدام أحدث المركبات.'),
            _buildFeatureCard(Icons.school, 'امتحان نظري تفاعلي',
                'نموذج محاكاة ذكي لأسئلة الامتحان النظري.'),
            _buildFeatureCard(Icons.schedule, 'تنظيم المواعيد',
                'إدارة جدول التدريب والعطل بكل سلاسة.'),
            _buildFeatureCard(Icons.event_available, 'حجز الجلسات بسهولة',
                'اختيار المدرب والوقت الأنسب في خطوات بسيطة.'),
            const SizedBox(height: 28),

            const Text(
              'ثقتكم هي محركنا. مع "مدرسة قيادة"، اكتشفوا تجربة تعليم قيادة حديثة وآمنة. 🚗💡',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 12,
              children: [
                _contactInfo(Icons.phone, '4460070'),
                _contactInfo(FontAwesomeIcons.whatsapp, '0960007404'),
                _contactInfo(Icons.location_on,
                    'الشهبندر – طلعة وزارة التربية – جادة عمر المختار'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryColor, size: 28),
        title: Text(title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _contactInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
