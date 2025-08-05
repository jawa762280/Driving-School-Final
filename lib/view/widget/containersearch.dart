import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:driving_school/controller/search_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/appimages.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/view/widget/my_button.dart';
import 'package:driving_school/view/widget/my_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ContainerSearch extends StatelessWidget {
  const ContainerSearch({
    super.key,
    required this.image,
    required this.name,
    required this.email,
    required this.trainerId,
    required this.userRole,
    this.reviews,
    required this.hasReview,
    required this.userId, 
  });

  final String image;
  final String name;
  final String email;
  final int trainerId;
  final String userRole;
  final Widget? reviews;
  final bool hasReview;
  final int userId;

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print('trainerId: $trainerId - hasReview: $hasReview');

    ImageProvider<Object> buildImageProvider(String imagePath) {
      if (imagePath.startsWith('http')) {
        return NetworkImage(imagePath);
      } else {
        return AssetImage(AppImages.defaultUser);
      }
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: buildImageProvider(image),
                backgroundColor: Colors.grey.shade200,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    reviews!,
                  ],
                ),
              ),
              if (userRole == 'student')
                GestureDetector(
                  onTap: hasReview
                      ? null
                      : () {
                          studentReviewDialog(context, trainerId);
                        },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: hasReview
                          ? Colors.grey.shade200
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      textDirection: TextDirection.ltr,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color:
                              hasReview ? Colors.grey : AppColors.primaryColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          hasReview ? 'تم التقييم' : 'تقييم',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: hasReview
                                ? Colors.grey
                                : AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 14.h),
          Divider(thickness: 1, color: Colors.grey.shade200),
          SizedBox(height: 10.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (userRole == 'student') ...[
                SizedBox(height: 10.h),
                buildActionButton(
                  icon: Icons.event_available_outlined,
                  label: "حجز جلسة تدريب",
                  onPressed: () {
                    Get.toNamed(AppRouts.trainingSessionsScreen, arguments: {
                      'trainer_id': trainerId,
                    });
                  },
                ),
                SizedBox(height: 10.h),
              ],
              buildActionButton(
                icon: Icons.star_border_sharp,
                label: "عرض تقييمات المدرب",
                onPressed: () {
                  Get.toNamed(AppRouts.trainerReviewsScreen, arguments: {
                    'trainer_id': trainerId,
                  });
                },
              ),
              if (userRole == 'student') ...[
                SizedBox(height: 10.h),
                buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: "إجراء محادثة",
                  onPressed: () {
                    final ctrl = Get.find<MySearchController>();
                    ctrl.openChat(userId, name);
                  },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 45.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20.sp, color: Colors.white),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void studentReviewDialog(BuildContext context, id) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: GetBuilder(
                init: MySearchController(),
                builder: (controller) {
                  return Obx(() {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('قيم المدرب'),
                                SizedBox(height: 20),
                                AnimatedRatingStars(
                                  initialRating: 3.5,
                                  minRating: 0.0,
                                  maxRating: 5.0,
                                  filledColor: Colors.amber,
                                  emptyColor: Colors.grey,
                                  filledIcon: Icons.star,
                                  halfFilledIcon: Icons.star_half,
                                  emptyIcon: Icons.star_border,
                                  onChanged: (double rating) {
                                    controller.rating = rating;
                                    controller.update();
                                  },
                                  displayRatingValue: true,
                                  interactiveTooltips: false,
                                  customFilledIcon: Icons.star,
                                  customHalfFilledIcon: Icons.star_half,
                                  customEmptyIcon: Icons.star_border,
                                  starSize: 30.0,
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  animationCurve: Curves.easeInOut,
                                  readOnly: false,
                                ),
                                SizedBox(height: 20),
                                MyTextformfield(
                                  maxLines: 5,
                                  mycontroller: controller.comment,
                                  keyboardType: TextInputType.visiblePassword,
                                  hintText: 'ملاحظة للمدرب',
                                  filled: true,
                                ),
                                SizedBox(height: 20),
                                MyButton(
                                  onPressed: () {
                                    controller.sendFeedbackStudent(id);
                                  },
                                  text: "ارسال",
                                ),
                              ],
                            ),
                    );
                  });
                }),
          ));
}
