import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iplanning/screens/mainScreen/LoginScreen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Bannerwiget extends StatefulWidget {
  const Bannerwiget({super.key, required this.child});
  final Widget child;
  @override
  State<Bannerwiget> createState() => _BannerwigetState();
}

class _BannerwigetState extends State<Bannerwiget> {
  // var isChanged = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0, 0, 0, 0.27],
                    colors: [
                      Color(0xffB9DAFB),
                      Color(0xff9895EE),
                      Color(0xffC55492),
                      Color(0xffECACAD)
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
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
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
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
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
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
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
            child: Container(),
          ),
          widget.child,
        ],
      ),
    );
  }
}
