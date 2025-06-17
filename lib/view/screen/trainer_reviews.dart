import 'package:driving_school/controller/trainer_reviews_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TrainerReviews extends StatelessWidget {
  const TrainerReviews({super.key});

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
            backgroundColor: Colors.grey.shade100,
            body: ListView(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 16),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.reviews.length,
                  itemBuilder: (context, i) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person_2_outlined,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'إسم الطالب : ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                controller.reviews[i]['student_name']
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.star_border,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'التقييم : ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              for (var index = 0;
                                  index <
                                      int.parse(controller.reviews[i]['rating']
                                          .toString());
                                  index++)
                                Icon(Icons.star, color: Colors.amber),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'التعليق : ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                controller.reviews[i]['comment'].toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
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
