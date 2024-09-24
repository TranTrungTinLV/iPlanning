// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
  List inviteEvents;
  double eventCost;
  EventsPostModel({
    required this.event_name,
    required this.eventImage,
    required this.event_id,
    // required this.category_id,
    required this.eventCost,
    this.category_id,
    required this.eventDateEnd,
    required this.eventDateStart,
    required this.uid,
    required this.location,
    required this.createAt,
    required this.inviteEvents,
  });

  factory EventsPostModel.fromMap(Map<String, dynamic> json) {
    return EventsPostModel(
        event_name: json['event_name'] as String,
        eventCost: json['eventCost'] as double,
        event_id: json['event_id'] as String,
        eventImage: json['eventImage'] as String,
        category_id:
            json['category_id'] != null ? json['category_id'] as String : null,
        eventDateStart: json['eventDateStart'] as Timestamp,
        eventDateEnd: json['eventDateEnd'] as Timestamp,
        uid: json['uid'] as String,
        location: json['location'] as String,
        createAt: json['createAt'] as Timestamp, // Chuyển đổi từ chuỗi ISO 8601
        inviteEvents: List.from(
          (json['inviteEvents'] as List),
        ));
  }
  Map<String, dynamic> toJson() {
    return {
      'event_name': event_name,
      'eventCost': eventCost,
      'event_id': event_id,
      'eventImage': eventImage,
      'category_id': category_id,
      'eventDateEnd': eventDateEnd,
      'eventDateStart': eventDateStart,
      'uid': uid,
      'location': location,
      'createAt': createAt,
      'inviteEvents': inviteEvents,
    };
  }
}
