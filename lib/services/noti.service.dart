import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';

class AlarmNotifier extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  StreamSubscription<User?>? _authSubscription;
  AlarmNotifier(this.flutterLocalNotificationsPlugin) {
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
      }
    }
  }

  void _listenForJoinRequests() {
    final user = authInstance.currentUser;
    if (user == null) {
      print("User is not logged in");
      return; // Ngăn hàm thực thi nếu chưa đăng nhập
    }
    firestoreInstance
        .collection("eventPosts")
        .where('uid', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      for (var eventDoc in snapshot.docs) {
        final List<dynamic>? isPending = eventDoc['isPending'];
        print("Pending requests: $isPending");
        if (isPending != null && isPending.isNotEmpty) {
          for (var pendingUser in isPending) {
            firestoreInstance
                .collection('users')
                .doc(pendingUser)
                .get()
                .then((uid) {
              final userName = uid['name'];
              showNotification(
                "Yêu cầu tham gia sự kiện",
                "$userName muốn tham gia sự kiện của bạn.",
                eventDoc['event_id'],
              );
            });
          }
        }
      }
    });
  }

  Future<void> initialization(
      Function(String? payload) onNotificationClick) async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print("Notification clicked with payload: ${details.payload}");
        onNotificationClick(details.payload);
      },
    );
  }

  Future<void> showNotification(
      String title, String body, String eventId) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'iplaning_channel',
      'Event Notifications Channel',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notifacation'),
      priority: Priority.high,
      importance: Importance.max,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    print("Attempting to show notification: $title - $body");

    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: eventId);
  }

  Future<void> requestNotificationsPermission() async {
    final androidGuard =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    bool? permissionGranted =
        await androidGuard?.requestNotificationsPermission();
    if (permissionGranted != true) {
      print("Notification permission not granted.");
      // return;
    } else {
      print("Notification permission granted.");
    }
  }
}
