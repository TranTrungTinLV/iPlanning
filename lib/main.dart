import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iplanning/firebase_options.dart';
import 'package:iplanning/screens/notification.dart';
import 'package:iplanning/screens/splashScreen.dart';
import 'package:iplanning/services/categories.service.dart';
import 'package:iplanning/services/noti.service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final alarmNotifierProvider = ChangeNotifierProvider<AlarmNotifier>((ref) {
  final notifier = AlarmNotifier(flutterLocalNotificationsPlugin);

  notifier.initialization((payload) {
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => NotificationScreen(
        getPicture: () {},
      ),
    ));
    return notifier;
  });

  return notifier;
});

void main() async {
  await dotenv.load(fileName: ".env");
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
        ref.watch(alarmNotifierProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          home: SplashScreen(),
        );
      },
    );
  }
}
