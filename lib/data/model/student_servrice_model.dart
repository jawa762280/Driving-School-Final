import 'package:driving_school/core/constant/appimages.dart';

class StudentServiceModel {
  final String imagePath;
  final String title;
  final String subtitle;

  StudentServiceModel({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}

final List<StudentServiceModel> studentServices = [
  StudentServiceModel(
    imagePath: AppImages.exam,
    title: "اختبار نظري",
    subtitle: "ابدأ الاختبار النظري",
  ),
  StudentServiceModel(
    imagePath: AppImages.resulte,
    title: "عرض نتائجي",
    subtitle: "نتائجك في التدريب والاختبارات",
  ),
  StudentServiceModel(
    imagePath: AppImages.booking,
    title: "حجز اوتوماتيكي",
    subtitle: "احجز مواعيدك بسهولة",
  ),
  StudentServiceModel(
    imagePath: AppImages.drivingTest,
    title: "موعد اختبار عملي",
    subtitle: "تحقق من مواعيدك العملية",
  ),
  StudentServiceModel(
    imagePath: AppImages.podts,
    title: "عرض المدونات",
    subtitle: "اقرأ آخر المقالات",
  ),
  StudentServiceModel(
    imagePath: AppImages.license,
    title: "طلب رخصة",
    subtitle: "قدّم طلب رخصتك هنا",
  ),
  StudentServiceModel(
    imagePath: AppImages.showLicense,
    title: "رخصاتي",
    subtitle: "استعرض رخصك الحالية",
  ),
  StudentServiceModel(
    imagePath: AppImages.chat,
    title: "قائمة المحادثات",
    subtitle: "استعرض المحادثات السابقة والحالية",
  ),
  StudentServiceModel(
    imagePath: AppImages.cars,
    title: "عرض السيارات",
    subtitle: "استعرض السيارات الموجودة في المدرسة",
  ),
];
