import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/screens/mainScreen/homeScreens.dart';
import 'package:iplanning/screens/phoneScreen.dart';
import 'package:iplanning/screens/welcomeScreen.dart';
import 'package:iplanning/services/auth.dart';
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

    Future.delayed(const Duration(seconds: 2), () async {
      try {
        final user = authInstance.currentUser;

        if (user != null) {
          // Fetch user data from Firestore
          UserModel? userDoc = await AuthenticationService().getUserData();
          if (userDoc != null) {
            print('Dữ liệu người dùng: ${userDoc.toJson()}');
            if (userDoc.isVerify == false) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => PhoneScreen(
                          phoneNumber: userDoc.phone,
                        )),
                (route) => false,
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Homescreens()),
              );
            }
          } else {
            print("Không tìm thấy tài liệu người dùng");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Welcomescreen()),
            );
          }
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Welcomescreen()),
          );
        }
      } catch (e) {
        print("Lỗi trong quá trình tải dữ liệu người dùng: $e");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Welcomescreen()),
        );
      }
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
