import 'package:driving_school/core/constant/approuts.dart';
import 'package:flutter/material.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/appimages.dart';
import 'package:get/get.dart';

class ExamsHomeScreen extends StatelessWidget {
  const ExamsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text(
          "الامتحانات",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shadowColor: AppColors.primaryColor.withAlpha((0.4 * 255).toInt()),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            "كيف تود عرض الامتحانات؟",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  FancyExamCard(
                    image: AppImages.exam,
                    title: "عرض جميع الامتحانات",
                    onTap: () {
                      Get.toNamed(AppRouts.trainerExamScreen);
                    },
                  ),
                  const SizedBox(height: 30),
                  FancyExamCard(
                    image: AppImages.test,
                    title: "عرض الامتحانات حسب النوع",
                    onTap: () {
                      Get.toNamed(AppRouts.showExamByTypeScreen);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FancyExamCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;

  const FancyExamCard({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha((0.2 * 255).toInt()),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor.withAlpha((0.08 * 255).toInt()),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 25),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
