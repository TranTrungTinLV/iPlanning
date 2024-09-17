import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iplanning/screens/HomePage.dart';
import 'package:iplanning/screens/welcomeScreen.dart';
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
          final user = FirebaseAuth.instance.currentUser;
          return user != null ? Homepage() : Welcomescreen();
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
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0, 0, 0, 0.27],
                    colors: [
                      Color(0xffB9DAFB),
                      Color(0xff9895EE),
                      Color(0xffC55492),
                      Color(0xffECACAD)
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.elliptical(300, 300))),
              height: 130,
              width: double.infinity,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.maxFinite,
              child: Stack(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.elliptical(400, 400)),
                        gradient: LinearGradient(
                          stops: [0, 0.27, 0.57, 0.81, 1],
                          colors: [
                            Color(0xffB9DAFB),
                            Color(0xffECACAD),
                            Color(0xff9895EE),
                            Color(0xff90A2F8),
                            Color(0xffC55492),
                          ],
                        ),
                      ),
                      width: 174,
                      height: 140,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.elliptical(400, 400)),
                        gradient: LinearGradient(
                          stops: [0, 0.27, 0.57, 0.81, 1],
                          colors: [
                            Color(0xffB9DAFB),
                            Color(0xffECACAD),
                            Color(0xff9895EE),
                            Color(0xff90A2F8),
                            Color(0xffC55492),
                          ],
                        ),
                      ),
                      width: 174,
                      height: 140,
                    ),
                  ],
                ),
              ]),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
            child: Container(),
          ),
          Center(
            child: GradientText(
              'iPlanning',
              colors: [Color(0xff5669FF), Color(0xff00F8FF)],
              style: TextStyle(fontSize: 48.0, fontFamily: 'Italiana'),
            ),
          ),
        ],
      ),
    );
  }
}
