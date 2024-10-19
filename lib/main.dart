import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iplanning/firebase_options.dart';
import 'package:iplanning/screens/splashScreen.dart';
import 'package:iplanning/services/categories.dart';
import 'package:iplanning/sqlhelper/note_sqlife.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NoteSQLHelper.getDatabase;
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CategoriesMethod().uploadDefaultCategories();
  runApp(iPlanApp());
}

class iPlanApp extends StatelessWidget {
  const iPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
