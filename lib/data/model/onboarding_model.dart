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
      title: "Start Your Driving \n Journey",
      description:
          "Learn the rules of the road with interactive \n  lessons and real exam questions."),
  OnboardingModel(
      image: AppImages.onboardingTwoImage,
      title: "Practice Anytime, \n Anywhere",
      description:
          "Take mock tests, track your progress, and get \n ready to pass with confidence."),
  OnboardingModel(
      image: AppImages.onboardingThreeImage,
      title: "Your Road to \n Success",
      description: "Get tips, reminders, and support every step of the \n way to becomea safe driver.")
];
