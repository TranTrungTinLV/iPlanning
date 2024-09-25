import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iplanning/models/Budget.dart';
import 'package:iplanning/models/user_models.dart';

class EventsPostModel {
  String event_name;
  String event_id;
  String? category_id;
  Timestamp eventDateStart;
  String eventImage;
  Timestamp eventDateEnd;
  String uid; //user_id
  String location;
  Timestamp createAt;
  // List inviteEvents;

  // relationship users
  List<UserModel> users;
  Budget budget;
  EventsPostModel({
    required this.event_name,
    required this.eventImage,
    required this.event_id,
    // required this.category_id,
    required this.budget,
    this.category_id,
    required this.users,
    required this.eventDateEnd,
    required this.eventDateStart,
    required this.uid,
    required this.location,
    required this.createAt,
    // required this.inviteEvents,
  });

  factory EventsPostModel.fromMap(Map<String, dynamic> json) {
    return EventsPostModel(
      event_name: json['event_name'] as String,
      budget: json['budget'] as Budget,
      event_id: json['event_id'] as String,
      eventImage: json['eventImage'] as String,
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
      // inviteEvents: List.from(
      //   (json['inviteEvents'] as List),
      // ),
    );
  }

  set userLists(UserModel user) {
    users.add(user);
  }

  Map<String, dynamic> toJson() {
    return {
      'event_name': event_name,
      'budget': budget,
      'event_id': event_id,
      'eventImage': eventImage,
      'category_id': category_id,
      'eventDateEnd': eventDateEnd,
      'eventDateStart': eventDateStart,
      'uid': uid,
      'location': location,
      'createAt': createAt,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}
