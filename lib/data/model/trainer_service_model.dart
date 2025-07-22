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
    imagePath: 'assets/images/noun-calendar-5022159.png',
    title: "إنشاء جدول تدريب",
    subtitle: "ابدأ بإنشاء جداول التدريب الخاصة بك",
  ),
  TrainerServiceModel(
    imagePath: 'assets/images/schedule.png',
    title: "عرض جداول التدريب",
    subtitle: "شاهد جميع الجداول التدريبية الخاصة بك",
  ),
  TrainerServiceModel(
    imagePath: 'assets/images/vacation.png',
    title: "طلب إجازة",
    subtitle: "أرسل طلب إجازتك بسهولة",
  ),
  TrainerServiceModel(
    imagePath: 'assets/images/vacation.png',
    title: "عرض الإجازات",
    subtitle: "اطلع على سجل الإجازات الخاصة بك",
  ),
  TrainerServiceModel(
    imagePath: 'assets/images/test2.png',
    title: "إنشاء امتحان",
    subtitle: "قم بإعداد امتحان جديد للطلاب",
  ),
  TrainerServiceModel(
    imagePath: 'assets/images/noun-exam-7921292.png',
    title: "عرض الامتحانات",
    subtitle: "راجع جميع الامتحانات السابقة",
  ),
  TrainerServiceModel(
    imagePath: 'assets/images/breakdown2.png',
    title: "إبلاغ عطل سيارة",
    subtitle: "سجّل الأعطال التي تواجهها في السيارة",
  ),
  TrainerServiceModel(
    imagePath: 'assets/images/breakdown4.png',
    title: "عرض أعطال السيارات",
    subtitle: "استعرض الأعطال المسجلة مسبقًا",
  ),
  TrainerServiceModel(
    imagePath: 'assets/images/noun-chat-7772420.png',
    title: "قائمة المحادثات",
    subtitle: "استعرض المحادثات السابقة والحالية",
  ),
  TrainerServiceModel(
    imagePath: 'assets/images/car.png',
    title: "عرض السيارات",
    subtitle: "استعرض السيارات الموجودة في المدرسة",
  ),
];
