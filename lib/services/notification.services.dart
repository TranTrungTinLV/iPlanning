import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationService(this._notificationsPlugin);
  Future<void> initialize(Function(String? payload) onNotificationClick) async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print("Notification clicked with payload: ${details.payload}");
        onNotificationClick(details.payload);
      },
    );
  }

  Future<void> showNotification(
      String title, String body, String payload) async {
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

    await _notificationsPlugin.show(0, title, body, notificationDetails,
        payload: payload);
  }

  Future<void> requestPermission() async {
    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    bool? granted =
        await androidImplementation?.requestNotificationsPermission();

    if (granted == true) {
      print("Quyền thông báo đã được cấp.");
    } else {
      print("Quyền thông báo bị từ chối.");
    }
  }
}
