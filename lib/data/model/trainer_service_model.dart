import 'package:driving_school/core/constant/appimages.dart';

class TrainerServiceModel {
  final String imagePath;
  final String title;
  final String subtitle;

  TrainerServiceModel({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}

final List<TrainerServiceModel> trainerServices = [
  TrainerServiceModel(
    imagePath: AppImages.calendar,
    title: "إنشاء جدول تدريب",
    subtitle: "ابدأ بإنشاء جداول التدريب الخاصة بك",
  ),
  TrainerServiceModel(
    imagePath: 'assets/images/schedule.png',
    title: "عرض جداول التدريب",
    subtitle: "شاهد جميع الجداول التدريبية الخاصة بك",
  ),
  TrainerServiceModel(
    imagePath: AppImages.vacation,
    title: "طلب إجازة",
    subtitle: "أرسل طلب إجازتك بسهولة",
  ),
  TrainerServiceModel(
    imagePath: AppImages.vacation,
    title: "عرض الإجازات",
    subtitle: "اطلع على سجل الإجازات الخاصة بك",
  ),
  TrainerServiceModel(
    imagePath: AppImages.creatExam,
    title: "إنشاء امتحان",
    subtitle: "قم بإعداد امتحان جديد للطلاب",
  ),
  TrainerServiceModel(
    imagePath: 'assets/images/noun-exam-7921292.png',
    title: "عرض الامتحانات",
    subtitle: "راجع جميع الامتحانات السابقة",
  ),
  TrainerServiceModel(
    imagePath: AppImages.breakdown,
    title: "إبلاغ عطل سيارة",
    subtitle: "سجّل الأعطال التي تواجهها في السيارة",
  ),
  TrainerServiceModel(
    imagePath: AppImages.showBreakdown,
    title: "عرض أعطال السيارات",
    subtitle: "استعرض الأعطال المسجلة مسبقًا",
  ),
  TrainerServiceModel(
    imagePath: AppImages.chat,
    title: "قائمة المحادثات",
    subtitle: "استعرض المحادثات السابقة والحالية",
  ),
  TrainerServiceModel(
    imagePath: AppImages.cars,
    title: "عرض السيارات",
    subtitle: "استعرض السيارات الموجودة في المدرسة",
  ),
];
