import 'package:driving_school/controller/show_car_faults_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShowCarFaults extends StatelessWidget {
  const ShowCarFaults({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShowCarFaultsController>(
      init: ShowCarFaultsController(),
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("أعطال السيارات"),
            centerTitle: true,
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                tooltip: 'تحديث',
                onPressed: () {
                  ctrl.showFaults();
                },
              ),
            ],
          ),
          body: Obx(() {
            if (ctrl.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: Colors.green));
            }

            if (ctrl.faults.isEmpty) {
              return const Center(child: Text("لا توجد أعطال حالياً"));
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: ctrl.faults.length,
              itemBuilder: (ctx, idx) {
                final f = ctrl.faults[idx];
                final car = f['car'];
                final trainerName = f['trainer']['trainer_name'];
                final status = f['status'];
                final comment = f['comment'];

                return _buildFaultCard(car, trainerName, status, comment);
              },
            );
          }),
        );
      },
    );
  }

  Widget _buildFaultCard(car, trainerName, status, comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Icon(Icons.directions_car,
                    color: AppColors.primaryColor, size: 32.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  '${car['make']} ${car['model']}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              _statusChip(status),
            ],
          ),
          Divider(color: Colors.grey.shade300, height: 24.h),
          _infoRow(Icons.person_outline, "مقدم البلاغ:", trainerName),
          SizedBox(height: 8.h),
          _infoRow(Icons.comment_outlined, "العطل:", comment),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$label ',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: Colors.black87),
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusChip(String status) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'قيد المعالجة':
        bg = Colors.orange.shade100;
        fg = Colors.orange.shade800;
        break;
      case 'تم الإصلاح':
        bg = Colors.green.shade100;
        fg = Colors.green.shade800;
        break;
      default:
        bg = Colors.grey.shade200;
        fg = Colors.grey.shade800;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status,
        style:
            TextStyle(color: fg, fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
