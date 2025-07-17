import 'package:driving_school/controller/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/approuts.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key, required this.image, required this.widget});

  final Image image;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    final NotificationsController controller =
        Get.put(NotificationsController());

    return Container(
      padding: EdgeInsets.all(10.w),
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 65.w,
            height: 65.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: image,
          ),
          Row(
            children: [
              SizedBox(width: 10.w),
              Obx(() {
                final unreadCount = controller.notifications
                    .where((n) => n['read_at'] == null)
                    .length;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    InkWell(
                      borderRadius:
                          BorderRadius.circular(20), 
                      onTap: () {
                        Get.toNamed(AppRouts.notificationsScreen);
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.all(8.0), 
                        child: Icon(
                          Icons.notifications_active_outlined,
                          size: 28.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
              widget,
            ],
          ),
        ],
      ),
    );
  }
}
