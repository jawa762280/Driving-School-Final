import 'package:flutter/material.dart';

class TrainerServiceModel {
  final IconData icon;
  final String title;

  TrainerServiceModel({
    required this.icon,
    required this.title,
  });
}

final List<TrainerServiceModel> trainerServices = [
  TrainerServiceModel(
      icon: Icons.directions_car, title: "انشاء جداول التدريب "),
  TrainerServiceModel(
      icon: Icons.schedule_outlined, title: "عرض جداولي التدريب "),
  TrainerServiceModel(icon: Icons.schedule_outlined, title: "طلب اجازة "),
  TrainerServiceModel(icon: Icons.schedule_outlined, title: "عرض الاجازات"),
  TrainerServiceModel(
      icon: Icons.text_snippet_outlined, title: "انشاء امتحان "),
  TrainerServiceModel(
      icon: Icons.text_snippet_outlined, title: " عرض الامتحانات"),
];
