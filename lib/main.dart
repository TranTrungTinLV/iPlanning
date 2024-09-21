import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:iplanning/firebase_options.dart';
import 'package:iplanning/screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(iPlanApp());
}

class iPlanApp extends StatelessWidget {
  const iPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
