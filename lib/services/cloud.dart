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

  invitedEvents(String uid, String eventId, String isStatus) async {
    try {
      DocumentSnapshot eventSnapshot = await postEvents.doc(eventId).get();

      if (eventSnapshot.exists && eventSnapshot.data() != null) {
        List inviting = (eventSnapshot.data()! as dynamic)['isPending'] ?? [];
        List acceptList =
            (eventSnapshot.data()! as dynamic)['isAccepted'] ?? [];
        List rejectList =
            (eventSnapshot.data()! as dynamic)['isRejected'] ?? [];

        if (inviting.contains(uid)) {
          if (isStatus == 'isPending') {
            if (inviting.contains(uid)) {
              // Nếu `uid` đã có trong `isPending`, thực hiện xóa (Uninvite)
              await postEvents.doc(eventId).update({
                'isPending': FieldValue.arrayRemove([uid]),
              });
            } else {
              // Nếu `uid` chưa có trong `isPending`, thực hiện thêm (Invite)
              await postEvents.doc(eventId).update({
                'isPending': FieldValue.arrayUnion([uid]),
              });
            }
          }
          if (isStatus == 'isAccepted') {
            // Chấp nhận: xóa khỏi isPending và thêm vào isAccept
            await postEvents.doc(eventId).update({
              'isPending': FieldValue.arrayRemove([uid]),
              'isAccepted': FieldValue.arrayUnion([uid]),
            });
          } else if (isStatus == 'isRejected') {
            // Từ chối: xóa khỏi isPending và thêm vào isRejected
            await postEvents.doc(eventId).update({
              'isPending': FieldValue.arrayRemove([uid]),
              'isRejected': FieldValue.arrayUnion([uid]),
            });
          }
        } else if (isStatus == 'isAccepted' && acceptList.contains(uid)) {
          // Xóa khỏi isAccept nếu cần hủy bỏ (tùy vào logic của bạn)
          await postEvents.doc(eventId).update({
            'isAccepted': FieldValue.arrayRemove([uid]),
          });
        } else if (isStatus == 'isRejected' && rejectList.contains(uid)) {
          // Xóa khỏi isRejected nếu cần (tùy vào logic của bạn)
          await postEvents.doc(eventId).update({
            'isRejected': FieldValue.arrayRemove([uid]),
          });
        } else {
          // Nếu `isStatus` là `isAccept` hoặc `isReject`, thêm vào trạng thái tương ứng
          await postEvents.doc(eventId).update({
            isStatus: FieldValue.arrayUnion([uid]),
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

  wishlistUser(String uid, String eventId) async {
    try {
      // Truy vấn tài liệu người dùng từ collection 'users' dựa vào uid
      DocumentSnapshot userSnapshot = await users.doc(uid).get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        // Lấy danh sách wishlist hiện tại (nếu có)
        List wishlist = (userSnapshot.data()! as dynamic)['wishlist'] ?? [];

        if (wishlist.contains(eventId)) {
          // Nếu sự kiện đã có trong wishlist, xóa khỏi danh sách (unwishlist)
          await users.doc(uid).update({
            'wishlist': FieldValue.arrayRemove([eventId]),
          });
          Fluttertoast.showToast(msg: "Removed from wishlist");
        } else {
          // Nếu sự kiện chưa có trong wishlist, thêm vào danh sách
          await users.doc(uid).update({
            'wishlist': FieldValue.arrayUnion([eventId]),
          });
          Fluttertoast.showToast(msg: "Added to wishlist");
        }
      } else {
        // Nếu tài liệu người dùng chưa tồn tại, tạo tài liệu với trường wishlist
        await users.doc(uid).set({
          'wishlist': [eventId],
        }, SetOptions(merge: true));
        Fluttertoast.showToast(msg: "Added to wishlist");
      }
    } catch (e) {
      print("Error in wishlistUser: $e");
    }
  }
}
