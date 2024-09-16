import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:iplanning/screens/splashScreen.dart';

void main() {
  runApp(iPlanApp());
}

class iPlanApp extends StatelessWidget {
  const iPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SplashScreen(),
      ),
    );
  }
}
