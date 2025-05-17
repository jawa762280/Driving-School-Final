class UserModel {
  final String id;
  final String email;
  final String name;
  final String? role;
  final String? imageUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.role,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'],
      imageUrl: json['image'], // لو ما في صورة ترجع null، عادي
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "role": role,
      "image": imageUrl,
    };
  }
}
