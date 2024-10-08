import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iplanning/models/Budget.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:iplanning/models/todoList.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/utils/InvitationStatus.dart';

class EventsPostModel {
  String event_name;
  String event_id;
  Timestamp eventDateStart;
  List<String>? eventImage;
  Timestamp eventDateEnd;
  String uid; //user_id
  String location;
  String profilePic;
  Timestamp createAt;
  List<ToDoList>? todoList;
  CategoryModel? categoryModel;
  // List inviteEvents;
  String? description;
  String username;
  String? eventType;
  List<String>? isPending;
  List<String>? isRejected;
  List<String>? isAccepted;
  Map<String, InvitationStatus>? invitationStatuses;

  List<UserModel> users;
  Budget? budget;
  // CategoryModel? category;
  EventsPostModel(
      {required this.event_name,
      this.categoryModel,
      this.todoList,
      this.eventType,
      this.isPending,
      this.isRejected,
      this.isAccepted,
      this.invitationStatuses,
      required this.eventImage,
      required this.profilePic,
      required this.event_id,
      this.budget,
      required this.username,
      required this.users,
      required this.eventDateEnd,
      required this.eventDateStart,
      required this.uid,
      required this.location,
      required this.createAt,
      this.description});

  factory EventsPostModel.fromJson(Map<String, dynamic> json) {
    return EventsPostModel(
      eventType: json['eventType'] as String,
      profilePic: json['profilePic'] as String,
      username: json['username'] as String,
      event_name: json['event_name'] as String,
      categoryModel: json['category'] != null
          ? CategoryModel.fromJson(
              json['category']) // Kiểm tra nếu category tồn tại
          : null,
      todoList: json['todoList'] != null
          ? (json['todoList'] as List)
              .map((item) => ToDoList.fromMap(item))
              .toList()
          : null,

      budget: json['budget'] != null
          ? Budget.fromMap(json['budget'] as Map<String, dynamic>)
          : null, // Convert budget properly
      event_id: json['event_id'] as String,
      isPending:
          json['isPending'] != null ? List<String>.from(json['isPending']) : [],
      isRejected: json['isRejected'] != null
          ? List<String>.from(json['isRejected'])
          : null,
      isAccepted: json['isAccepted'] != null
          ? List<String>.from(json['isAccepted'])
          : null,
      invitationStatuses: json['invitationStatuses'] != null
          ? Map<String, InvitationStatus>.from(json['invitationStatuses'].map(
              (key, value) => MapEntry(
                  key,
                  InvitationStatus.values.firstWhere(
                      (e) => e.toString() == 'InvitationStatus.' + value))))
          : null,
      description: json['description'] as String?,
      eventImage: json['eventImage'] != null
          ? List<String>.from(json['eventImage'])
          : null, // Ensure proper handling of eventImage

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
      'isPending': isPending,
      'isRejected': isRejected,
      'isAccepted': isAccepted,
      'invitationStatuses': invitationStatuses?.map(
          (key, value) => MapEntry(key, value.toString().split('.').last)),
      'username': username,
      'profilePic': profilePic,
      'budget': budget?.toJson(),
      'event_id': event_id,
      'eventImage': eventImage,
      'category_id': categoryModel?.category_id,
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
