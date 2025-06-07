class TrainerModel {
  final int id;
  final int userId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String dateOfBirth;
  final String address;
  final String gender;
  final String image;
  final String status;
  final String licenseNumber;
  final String licenseExpiryDate;
  final String experience;
  final String trainingType;

  TrainerModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.address,
    required this.gender,
    required this.image,
    required this.status,
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.experience,
    required this.trainingType,
  });

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    return TrainerModel(
      id: json['id'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      dateOfBirth: json['date_of_Birth'],
      address: json['address'],
      gender: json['gender'],
      image: json['image'],
      status: json['status'],
      licenseNumber: json['license_number'],
      licenseExpiryDate: json['license_expiry_date'],
      experience: json['experience'],
      trainingType: json['training_type'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "date_of_Birth": dateOfBirth,
        "address": address,
        "gender": gender,
        "image": image,
        "status": status,
        "license_number": licenseNumber,
        "license_expiry_date": licenseExpiryDate,
        "experience": experience,
        "training_type": trainingType,
      };
}
