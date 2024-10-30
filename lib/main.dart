import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iplanning/firebase_options.dart';
import 'package:iplanning/screens/splashScreen.dart';
import 'package:iplanning/services/categories.dart';
import 'package:iplanning/services/noti.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final alarmNotifierProvider = ChangeNotifierProvider<AlarmNotifier>((ref) {
  final notifier = AlarmNotifier(flutterLocalNotificationsPlugin);

  // Khởi tạo thông báo và lắng nghe ngay từ khi ứng dụng chạy
  notifier.initialization((payload) {
    print("Notification clicked with payload: $payload");
  });

  return notifier;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      print("Notification clicked with payload: ${details.payload}");
    },
  );

  await CategoriesMethod().uploadDefaultCategories();

  runApp(
    ProviderScope(
      child: iPlanApp(),
    ),
  );
  print("flutterLocalNotificationsPlugin initialized successfully");
}

class iPlanApp extends StatelessWidget {
  const iPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(
            alarmNotifierProvider); // Đảm bảo AlarmNotifier hoạt động ngay khi ứng dụng khởi động
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
