import 'package:iplanning/models/events_model.dart';

class UserModel {
  String uid;
  String? country;
  String email;
  String name;
  String? phone;
  String? avatars;
  String? newAvatars;
  List<EventsPostModel>? eventPostModel;
  List<String>? wishList;

  UserModel({
    this.wishList,
    required this.uid,
    this.newAvatars,
    required this.email,
    required this.name,
    this.eventPostModel,
    this.country,
    this.phone,
    this.avatars,
  });

  // Factory constructor từ JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      eventPostModel: [],
      uid: json['uid'] as String,
      country: json['country'] as String?,
      avatars: json['avatars'] as String?,
      newAvatars: json['newAvatars'] as String?,
      wishList:
          json['wishList'] != null ? List<String>.from(json['wishList']) : [],
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
    );
  }

  // Chuyển đổi đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'country': country,
      'email': email,
      'name': name,
      'wishList': wishList,
      'phone': phone,
      'avatars': avatars,
      'newAvatars': newAvatars,
      'eventPostModel': eventPostModel?.map((event) => event.toJson()).toList(),
    };
  }

  // if newAvatars
  String? get displayAvatar {
    return newAvatars ?? avatars;
  }

  set addEvent(EventsPostModel event) {
    eventPostModel!.add(event);
  }
}
