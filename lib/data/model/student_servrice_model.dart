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
    imagePath: 'assets/images/exam.png',
    title: "اختبار نظري",
    subtitle: "ابدأ الاختبار النظري",
  ),
  StudentServiceModel(
    imagePath: 'assets/images/resulte.png',
    title: "عرض نتائجي",
    subtitle: "نتائجك في التدريب والاختبارات",
  ),
  StudentServiceModel(
    imagePath: 'assets/images/booking.png',
    title: "حجز اوتوماتيكي",
    subtitle: "احجز مواعيدك بسهولة",
  ),
  StudentServiceModel(
    imagePath: 'assets/images/noun-driving-testing-4647644.png',
    title: "موعد اختبار عملي",
    subtitle: "تحقق من مواعيدك العملية",
  ),
  StudentServiceModel(
    imagePath: 'assets/images/noun-post-it-4192177.png',
    title: "عرض المدونات",
    subtitle: "اقرأ آخر المقالات",
  ),
  StudentServiceModel(
    imagePath: 'assets/images/noun-license-7944334.png',
    title: "طلب رخصة",
    subtitle: "قدّم طلب رخصتك هنا",
  ),
  StudentServiceModel(
    imagePath: 'assets/images/driver-license.png',
    title: "رخصاتي",
    subtitle: "استعرض رخصك الحالية",
  ),
  StudentServiceModel(
  imagePath: 'assets/images/noun-chat-7772420.png',
  title: "قائمة المحادثات",
  subtitle: "استعرض المحادثات السابقة والحالية",
),
];
