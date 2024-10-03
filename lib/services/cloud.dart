import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/Budget.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/services/storage.dart';
import 'package:uuid/uuid.dart';

class ClouMethods {
  CollectionReference postEvents = firestoreInstance.collection('eventPosts');
  final User? user = authInstance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  uploadPost({
    required String event_name,
    required Timestamp eventDateEnd,
    required Timestamp eventDateStart,
    String? profilePic,
    String? category_id,
    String? eventType,
    required String username,
    required String uid, //user_id
    required String location,
    required List<Uint8List> eventImages,
    // required Budget budget,
    required String description,
  }) async {
    String res = 'Some Error';

    try {
      String eventId = const Uuid().v4().split('-')[0];
      List<String> postImageUrls = await uploadImageToStorage(
        eventImages,
        'eventPosts/$eventId',
        true,
      );
      EventsPostModel eventsPostModel = EventsPostModel(
          eventType: eventType ?? null,
          username: username,
          profilePic: profilePic ?? "",
          event_name: event_name,
          event_id: eventId,
          category_id: category_id,
          description: description,
          uid: uid,
          location: location,
          createAt: Timestamp.now(),
          eventDateEnd: eventDateEnd,
          eventDateStart: eventDateStart,
          eventImage: postImageUrls,
          // budget: budget,
          users: []);
      await postEvents.doc(eventId).set(eventsPostModel.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<List<EventsPostModel>> getAllEventPosts() async {
    try {
      QuerySnapshot snapshot = await postEvents.get();
      List<EventsPostModel> events = snapshot.docs.map((doc) {
        return EventsPostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return events;
    } catch (e) {
      print('Failed to get all event posts: $e');
      return [];
    }
  }

  invitedEvents(String uid, String eventId) async {
    try {
      DocumentSnapshot eventSnapshot = await postEvents.doc(eventId).get();

      if (eventSnapshot.exists && eventSnapshot.data() != null) {
        List inviting = (eventSnapshot.data()! as dynamic)['isPending'] ?? [];

        if (inviting.contains(uid)) {
          await postEvents.doc(eventId).update({
            'isPending': FieldValue.arrayRemove([uid]), // Huỷ mời tham gia
          });
        } else {
          await postEvents.doc(eventId).update({
            'isPending': FieldValue.arrayUnion([uid]) //  tham gia
          });
        }
      } else {
        print("Event document does not exist or data is null.");
      }
    } catch (e) {
      print("Error in invitedEvents: $e");
    }
    // return res;
  }
}
