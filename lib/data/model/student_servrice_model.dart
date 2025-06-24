import 'package:flutter/material.dart';

class StudentServiceModel {
  final IconData icon;
  final String title;

  StudentServiceModel({
    required this.icon,
    required this.title,
  });
}

final List<StudentServiceModel> studentServices = [
  StudentServiceModel(icon: Icons.edit_document, title: "توليد امتحان"),
  StudentServiceModel(icon: Icons.account_box, title: "حجز رخصة نظرية"),
  StudentServiceModel(
      icon: Icons.directions_car, title: "اختبار تجريبي مع تصحيح فوري"),
  StudentServiceModel(icon: Icons.phone_in_talk, title: "حجز رخصة عبر الاتصال"),
  StudentServiceModel(
      icon: Icons.calendar_month, title: "حجز موعد اختبار عملي"),
  StudentServiceModel(icon: Icons.drive_eta, title: "اختبار نظري"),
];
