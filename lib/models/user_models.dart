import 'dart:io';

class UserModel {
  final String? country;
  final String email;
  final String name;
  final String? phone;
  final String? avatars;
  UserModel({
    required this.email,
    required this.name,
    this.country,
    this.phone,
    this.avatars,
  });

  // Factory constructor từ JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      country: json['country'] as String?,
      avatars: json['avatars'] as String?,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
    );
  }

  // Chuyển đổi đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'email': email,
      'name': name,
      'phone': phone,
      'avatars': avatars,
    };
  }
}
