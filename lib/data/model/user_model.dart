import 'package:driving_school/data/model/trainer_model.dart';

class UserModel {
  final String userId;
  final String email;
  final String fullName;
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String? gender;
  final String? role;
  final String? imageUrl;
  final TrainerModel? trainer; // ✅ إضافة

  UserModel({
    required this.userId,
    required this.email,
    required this.fullName,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.role,
    this.imageUrl,
    this.trainer,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'].toString(),
      email: json['email'] ?? '',
      fullName: json['name'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      dateOfBirth: json['date_of_Birth'],
      gender: json['gender'],
      role: json['role'],
      imageUrl: json['image'],
      trainer: json['trainer'] != null
          ? TrainerModel.fromJson(json['trainer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "email": email,
      "name": fullName,
      "first_name": firstName,
      "last_name": lastName,
      "date_of_Birth": dateOfBirth,
      "gender": gender,
      "role": role,
      "image": imageUrl,
      "trainer": trainer?.toJson(),
    };
  }
}
