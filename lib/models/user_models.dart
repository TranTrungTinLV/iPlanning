import 'dart:io';

class UserModel {
  String? country;
  String email;
  String name;
  String? phone;
  String? avatars;
  String? newAvatars;
  UserModel({
    this.newAvatars,
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
      newAvatars: json['newAvatars'] as String?,
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
      'newAvatars': newAvatars,
    };
  }

  // if newAvatars
  String? get displayAvatar {
    return newAvatars ?? avatars;
  }
}
