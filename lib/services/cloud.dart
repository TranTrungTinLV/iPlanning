import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/Budget.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/services/categories.dart';
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
    bool? isPost,
    required CategoryModel category_id,
    String? eventType,
    required String username,
    required String uid, //user_id
    required String location,
    required List<Uint8List> eventImages,
    String? budget,
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
          todoList: [],
          eventType: eventType ?? null,
          username: username,
          profilePic: profilePic ?? "",
          event_name: event_name,
          event_id: eventId,
          categoryModel: category_id,
          description: description,
          uid: uid,
          location: location,
          createAt: Timestamp.now(),
          eventDateEnd: eventDateEnd,
          eventDateStart: eventDateStart,
          eventImage: postImageUrls,
          budget: budget,
          isPost: isPost ?? false,
          users: []);
      await CategoriesMethod()
          .updateCategoryEventIds(category_id.category_id, eventId);
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

        // Check UID
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
      // Lấy thông tin sự kiện
      DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('eventPosts')
          .doc(eventId)
          .get();

      // Lấy thông tin người dùng
      DocumentSnapshot userSnapshot = await users.doc(uid).get();
      if (!userSnapshot.exists) {
        print("Tài liệu không tồn tại.");
        return;
      }

      if (userSnapshot.exists && userSnapshot.data() != null) {
        List wishlist = (userSnapshot.data()! as dynamic)['wishlist'] ?? [];

        if (wishlist.contains(eventId)) {
          await users.doc(uid).update({
            'wishlist': FieldValue.arrayRemove([eventId]),
          });
          Fluttertoast.showToast(msg: "Removed from wishlist");
        } else {
          // Hành động add (thêm vào wishlist)
          if (eventSnapshot.exists && eventSnapshot.data() != null) {
            String eventCreatorUid = (eventSnapshot.data()!
                as dynamic)['uid']; // Lấy UID người tạo sự kiện

            if (eventCreatorUid == uid) {
              // Nếu sự kiện là của chính người dùng, không cho phép thêm vào wishlist
              Fluttertoast.showToast(
                  msg: "You cannot add your own event to the wishlist");
              return;
            }
          }

          // Thêm vào wishlist
          await users.doc(uid).update({
            'wishlist': FieldValue.arrayUnion([eventId]),
          });
          Fluttertoast.showToast(msg: "Added to wishlist");
        }
      }
    } catch (e) {
      print("Error in wishlistUser: $e");
    }
  }
}
