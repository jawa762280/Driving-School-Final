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
  StudentServiceModel(icon: Icons.edit_document, title: "اختبار نظري"),
  StudentServiceModel(
    icon: Icons.real_estate_agent_sharp,
    title: "عرض نتائجي",
  ),
  StudentServiceModel(icon: Icons.account_box, title: "حجز اوتوماتيكي"),
  StudentServiceModel(icon: Icons.directions_car, title: "موعد اختبار عملي"),
  StudentServiceModel(icon: Icons.phone_in_talk, title: "عرض المدونات"),
  StudentServiceModel(icon: Icons.insert_drive_file_rounded, title: "طلب رخصة"),
  StudentServiceModel(icon: Icons.file_copy_sharp, title: "رخصاتي"),
];
