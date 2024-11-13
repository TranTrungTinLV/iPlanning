import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iplanning/screens/mainScreen/LoginScreen.dart';
import 'package:iplanning/widgets/bannerWiget.dart';
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
        body: Bannerwiget(
      child: Center(
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
                    'Chào mừng đến với iPlanning',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 17.0,
                  ),
                  Text(
                    'Trải nghiệm lập kế hoạch ở đây thôi nào',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
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
        ),
      ),
    ));
  }
}
