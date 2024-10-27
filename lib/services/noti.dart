import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Alarm {
  static Future initialization(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
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

  static Future showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String title,
      String body,
      String eventId) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'iplaning_channel',
      'Event Notifications Channel',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notifacation'),
      priority: Priority.high,
      importance: Importance.max,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    print("Attempting to show notification: $title - $body");
    try {
      await flutterLocalNotificationsPlugin
          .show(0, title, body, notificationDetails, payload: eventId);
      print("Notification shown successfully");
    } catch (e) {
      print("Error showing notification: $e");
    }
    print("Notification should have been shown.");
  }
}
