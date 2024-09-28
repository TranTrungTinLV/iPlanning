import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iplanning/models/Budget.dart';
import 'package:iplanning/models/user_models.dart';

class EventsPostModel {
  String event_name;
  String event_id;
  String? category_id;
  Timestamp eventDateStart;
  List<String>? eventImage;
  Timestamp eventDateEnd;
  String uid; //user_id
  String location;
  String profilePic;
  Timestamp createAt;
  // List inviteEvents;
  String? description;
  String username;
  String? eventType;
  // relationship users
  List<UserModel> users;
  Budget budget;
  EventsPostModel(
      {required this.event_name,
      this.eventType,
      required this.eventImage,
      required this.profilePic,
      required this.event_id,
      required this.budget,
      this.category_id,
      required this.username,
      required this.users,
      required this.eventDateEnd,
      required this.eventDateStart,
      required this.uid,
      required this.location,
      required this.createAt,
      this.description});

  factory EventsPostModel.fromMap(Map<String, dynamic> json) {
    return EventsPostModel(
      eventType: json['eventType'] as String?,
      profilePic: json['profilePic'] as String,
      username: json['username'] as String,
      event_name: json['event_name'] as String,
      budget: json['budget'] as Budget,
      event_id: json['event_id'] as String,
      description: json['description'] as String?,
      eventImage: json['eventImage'] != null
          ? List<String>.from(json['eventImage'])
          : null, // Ensure proper handling of eventImage
      category_id:
          json['category_id'] != null ? json['category_id'] as String : null,
      eventDateStart: json['eventDateStart'] as Timestamp,
      eventDateEnd: json['eventDateEnd'] as Timestamp,
      uid: json['uid'] as String,
      location: json['location'] as String,
      createAt: json['createAt'] as Timestamp, // Chuyển đổi từ chuỗi ISO 8601
      users: (json['users'] as List)
          .map((userJson) => UserModel.fromJson(userJson))
          .toList(),
    );
  }

  set userLists(UserModel user) {
    users.add(user);
  }

  Map<String, dynamic> toJson() {
    return {
      'event_name': event_name,
      'eventType': eventType,
      'username': username,
      'profilePic': profilePic,
      'budget': budget.toJson(),
      'event_id': event_id,
      'eventImage': eventImage,
      'category_id': category_id,
      'eventDateEnd': eventDateEnd,
      'eventDateStart': eventDateStart,
      'uid': uid,
      'location': location,
      'createAt': createAt,
      'description': description,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}
