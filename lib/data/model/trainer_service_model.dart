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
  TrainerServiceModel(icon: Icons.directions_car, title: "مواعيد التدريب"),
];
