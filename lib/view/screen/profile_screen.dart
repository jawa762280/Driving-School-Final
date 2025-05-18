import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/appimages.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final String phoneNumber = "0991817817";
  final String username = "جوى";

  @override
  Widget build(BuildContext context) {
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
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(AppImages.defaultUser),
              ),
              const SizedBox(height: 10),
              Text(
                username,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Text(
                phoneNumber,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  side: BorderSide(color: Colors.black54),
                ),
                child: Text('تعديل معلومات الحساب'),
              ),
              const SizedBox(height: 20),
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
                    Divider(height: 1),
                    buildMenuTile(
                      Icons.directions_car,
                      'السيارات',
                      onTap: () {},
                    ),
                    Divider(height: 1),
                    buildMenuTile(
                      Icons.info_outline,
                      'معلومات عنا ',
                      onTap: () {},
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                      onTap: () {},
                    ),
                    Divider(height: 1),
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
            backgroundColor: Color(0xFFE7F3E7),
            child: Icon(icon, color: AppColors.primaryColor),
          ),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
