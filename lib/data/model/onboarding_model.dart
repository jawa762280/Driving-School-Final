import 'package:driving_school/core/constant/appimages.dart';

class OnboardingModel {
  final String? image;
  final String title;
  final String description;

  OnboardingModel(
      {required this.image, required this.title, required this.description});
}

List<OnboardingModel> onboardingList = [
  OnboardingModel(
      image: AppImages.onboardingOneImage,
      title: "ابدأ رحلة القيادة \n الخاصة بك",
      description:
          "تعلم قواعد الطريق من خلال الدروس التفاعلية \n  وأسئلة الامتحان الحقيقية"),
  OnboardingModel(
      image: AppImages.onboardingTwoImage,
      title: "تدرب في أي وقت \n وفي أي مكان",
      description:
          "قم بإجراء اختبارات تجريبية، وتتبع تقدمك \n واستعد للنجاح بثقة"),
  OnboardingModel(
      image: AppImages.onboardingThreeImage,
      title: "طريقك إلى \n النجاح",
      description:
          "احصل على النصائح والتذكيرات والدعم في كل خطوة على\n الطريق لتصبح سائقًا آمنًا")
];
