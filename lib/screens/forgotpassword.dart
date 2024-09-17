import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iplanning/widgets/button.dart';
import 'package:iplanning/widgets/textForm.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ForgotpasswordScreen extends StatefulWidget {
  const ForgotpasswordScreen({super.key});

  @override
  State<ForgotpasswordScreen> createState() => _ForgotpasswordScreenState();
}

class _ForgotpasswordScreenState extends State<ForgotpasswordScreen> {
  var _enteremail = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.9,
      ),
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
            child: Container(),
          ),
          Center(
            // child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextForm(
                            isLogin: false,
                            valueUser: _enteremail,
                            icon: Icons.email,
                            title: 'Your email',
                            validator: (value) {},
                            onSaved: (value) {
                              _enteremail = value!;
                            }),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        ButtonAuth(
                          colour: Color(0xffEDE5E5),
                          backgroundColour: Color(0xff54BA64),
                          textColour: Colors.white,
                          onTap: () {},
                          title: 'Reset Password',
                          isCheck: false,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
