class CarModel {
  final String licensePlate;
  final String model;
  final String year;
  final String make;
  final String color;
  final String? image;
  final String transmission;
  final bool isForSpecialNeeds;
  final String displayType;
  final String status;

  CarModel({
    required this.licensePlate,
    required this.model,
    required this.year,
    required this.make,
    required this.color,
    this.image,
    required this.transmission,
    required this.isForSpecialNeeds,
    required this.displayType,
    required this.status,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      licensePlate: json['license_plate'],
      model: json['model'],
      year: json['year'],
      make: json['make'],
      color: json['color'],
      image: json['image'],
      transmission: json['transmission'],
      isForSpecialNeeds: json['is_for_special_needs'],
      displayType: json['display_type'],
      status: json['status'],
    );
  }
}
