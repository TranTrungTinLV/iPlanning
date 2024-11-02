import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/screens/mainScreen/homeScreens.dart';
import 'package:iplanning/screens/welcomeScreen.dart';
import 'package:iplanning/widgets/bannerWiget.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          final user = authInstance.currentUser;
          return user != null ? const Homescreens() : const Welcomescreen();
        },
      ));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Bannerwiget(
      child: Center(
        child: GradientText(
          'iPlanning',
          colors: const [Color(0xff5669FF), Color(0xff00F8FF)],
          style: const TextStyle(fontSize: 48.0, fontFamily: 'Italiana'),
        ),
      ),
    ));
  }
}
