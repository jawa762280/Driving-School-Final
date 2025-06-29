import 'package:driving_school/controller/trainer_reviews_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TrainerReviewsScreen extends StatelessWidget {
  const TrainerReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: TrainerReviewsController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "تقييمات المدرب",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.primaryColor,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            backgroundColor: Colors.grey.shade300,
            body: ListView(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 16),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.reviews.length,
                  itemBuilder: (context, i) {
                    var review = controller.reviews[i];
                    return Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🧍‍♂️ صورة واسم الطالب
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22.r,
                                backgroundColor: AppColors.primaryColor
                                    .withAlpha((0.1 * 255).toInt()),
                                child: Icon(Icons.person,
                                    color: AppColors.primaryColor, size: 24),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  review['student_name'].toString(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),

                          // 🌟 التقييم بالنجوم والرقم
                          Row(
                            children: [
                              Wrap(
                                spacing: 2,
                                children: List.generate(
                                  int.tryParse(review['rating'].toString()) ??
                                      0,
                                  (index) => Icon(Icons.star_rounded,
                                      color: Colors.amber, size: 20),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${review['rating'].toString()}/5',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          // 💬 التعليق
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.format_quote_rounded,
                                    color: AppColors.primaryColor, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    review['comment']?.toString() ??
                                        'لا يوجد تعليق',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          );
        });
  }
}
