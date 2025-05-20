import 'package:driving_school/controller/profile_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: Text(
                  'الملف الشخصي',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // صورة الملف الشخصي
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'http${data.read('user')['image'].toString().split('http').last}'))),
              ),

              const SizedBox(height: 10),

              // الاسم الكامل
              Text(
                data.read('user')['first_name'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 5.h),

              // رقم الهاتف

              Text(
                data.read('user')['phone_number'],
                style: TextStyle(color: Colors.grey[700]),
              ),

              const SizedBox(height: 15),

              // زر تعديل معلومات الحساب
              OutlinedButton(
                onPressed: () {
                  controller.goToUpdateInformation();
                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  side: const BorderSide(color: Colors.black54),
                ),
                child: const Text('تعديل معلومات الحساب'),
              ),

              const SizedBox(height: 20),

              // القائمة الأولى
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    buildMenuTile(
                      Icons.schedule,
                      'جداول التدريب',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    buildMenuTile(
                      Icons.directions_car,
                      'السيارات',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    buildMenuTile(
                      Icons.info_outline,
                      'معلومات عنا ',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // القائمة الثانية
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    buildMenuTile(
                      Icons.delete_forever,
                      'حذف الحساب',
                      onTap: () {
                        controller.showDeleteAccountDialog();
                      },
                    ),
                    const Divider(height: 1),
                    buildMenuTile(
                      Icons.logout,
                      'تسجيل خروج',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuTile(IconData icon, String title, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFE7F3E7),
            child: Icon(icon, color: AppColors.primaryColor),
          ),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
