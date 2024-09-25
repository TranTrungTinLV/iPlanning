import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iplanning/screens/LoginScreen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
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
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: const Column(
                  children: [
                    Text(
                      'Welcome to iPlanning',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 17.0,
                    ),
                    Text(
                      'Create an account with us and experience seamless event planning.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => Loginscreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 60),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                        border: Border.all(
                          strokeAlign: 1.0,
                          color: const Color(0xff54BA64),
                        ),
                      ),
                      height: 50,
                      child: const Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                              color: Color(0xff54BA64),
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}
