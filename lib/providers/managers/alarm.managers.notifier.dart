import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/services/notification.services.dart';

class AlarmNotifier extends ChangeNotifier {
  final NotificationService _notificationService;

  StreamSubscription<User?>? _authSubscription;
  AlarmNotifier(this._notificationService) {
    _authSubscription = authInstance.authStateChanges().listen((user) {
      if (user != null) {
        print("User logged in: ${user.uid}");
        _checkVerify();
      } else {
        print("User is not logged in");
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    void dispose() {
      _authSubscription?.cancel(); // Cancels the subscription when not needed
      super.dispose();
    }
  }

  Future<void> _checkVerify() async {
    final user = authInstance.currentUser;
    if (user == null) return;
    final userDoc =
        await firestoreInstance.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      final isVerify = userDoc.data()?['isVerify'] ?? false;
      if (isVerify == true) {
        _listenForJoinRequests();
        _listenForAcceptedRequests();
        _listenForRequestUser();
      }
    }
  }

  void _listenForJoinRequests() {
    final user = authInstance.currentUser;
    if (user == null) {
      print("User is not logged in");
      return;
    }
    firestoreInstance
        .collection("eventPosts")
        .where('uid', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      for (var eventDoc in snapshot.docs) {
        final List<dynamic>? isPending = eventDoc['isPending'];
        final List<dynamic>? isAccepted = eventDoc['isAccepted'];
        print("Pending requests: $isPending");
        if (isPending != null && isPending.isNotEmpty) {
          for (var pendingUser in isPending) {
            if (isAccepted == null || !isAccepted.contains(pendingUser)) {
              firestoreInstance
                  .collection('users')
                  .doc(pendingUser)
                  .get()
                  .then((uid) {
                final userName = uid['name'];
                _notificationService.showNotification(
                  "Yêu cầu tham gia sự kiện",
                  "$userName muốn tham gia sự kiện của bạn.",
                  eventDoc['event_id'],
                );
              });
            }
          }
        }
      }
    });
  }

  void _listenForRequestUser() {
    final user = authInstance.currentUser;
    if (user == null) {
      print("User is not logged in");
      return;
    }
    firestoreInstance
        .collection("eventPosts")
        .where("isRequestInvite", arrayContains: user.uid)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        final eventData = doc.data() as Map<String, dynamic>;
        final eventName = eventData['event_name'] ?? "Sự kiện không xác định";
        final hostUid = eventData['uid'];

        firestoreInstance
            .collection('users')
            .doc(hostUid)
            .get()
            .then((hostDoc) {
          if (hostDoc.exists) {
            final hostName = hostDoc.data()?['name'] ?? "Người tổ chức";

            _notificationService.showNotification(
              "Lời mời tham gia sự kiện",
              "$hostName đã mời bạn tham gia sự kiện: $eventName.",
              doc.id,
            );
          }
        });
      }
    });
  }

  void _listenForAcceptedRequests() {
    final user = authInstance.currentUser;
    if (user == null) {
      print("User is not logged in");
      return;
    }

    firestoreInstance
        .collection("eventPosts")
        .where('isAccepted', arrayContains: user.uid)
        .snapshots()
        .listen((snapshot) {
      for (var eventDoc in snapshot.docs) {
        final String eventName =
            eventDoc['event_name'] ?? "Sự kiện không xác định";
        final String eventId = eventDoc['event_id'] ?? "";
        final String hostUid = eventDoc['uid'];

        firestoreInstance
            .collection('users')
            .doc(hostUid)
            .get()
            .then((hostDoc) {
          if (hostDoc.exists) {
            final hostName = hostDoc.data()?['name'] ?? "Người tổ chức";

            _notificationService.showNotification(
              "Tham gia sự kiện thành công",
              "Yêu cầu tham gia sự kiện của bạn đã được chấp nhận bởi $hostName.",
              eventId,
            );
          }
        });
      }
    });
  }

  Future<void> requestNotificationsPermission() async {
    await _notificationService.requestPermission();
  }

  Future<void> initializeNotifications(
      Function(String? payload) onNotificationClick) async {
    await _notificationService.initialize(onNotificationClick);
  }
}
