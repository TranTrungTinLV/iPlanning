import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iplanning/screens/forgotpassword.dart';
import 'package:iplanning/widgets/button.dart';
import 'package:iplanning/widgets/textForm.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  var _enterusername = '';
  var _enteremail = '';
  var _enterpassword = '';
  var _isLogin = false;
  var agreePersonalData = false;
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
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
            child: Container(),
          ),
          Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isLogin
                            ? Container()
                            : Center(
                                child: GradientText(
                                  'iPlanning',
                                  colors: [
                                    Color(0xff5669FF),
                                    Color(0xff00F8FF)
                                  ],
                                  style: TextStyle(
                                      fontSize: 48.0, fontFamily: 'Italiana'),
                                ),
                              ),
                        SizedBox(
                          height: 50,
                        ),
                        _isLogin
                            ? Container()
                            : Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 24.0,
                                ),
                              ),
                        SizedBox(
                          height: 30,
                        ),
                        _isLogin
                            ? TextForm(
                                isLogin: _isLogin,
                                valueUser: _enterusername,
                                icon: Icons.person,
                                title: 'Full Name',
                                // title2: 'Full Name',
                              )
                            : Container(),
                        TextForm(
                          isLogin: _isLogin,
                          valueUser: _enteremail,
                          icon: Icons.email,
                          title: 'email',
                        ),
                        TextForm(
                          isLogin: _isLogin,
                          valueUser: _enterpassword,
                          icon: Icons.password,
                          title: 'password',
                        ),
                        _isLogin
                            ? TextForm(
                                isLogin: _isLogin,
                                valueUser: _enterpassword,
                                icon: Icons.password,
                                title: 'Confirm password',
                              )
                            : Container(),
                        _isLogin
                            ? Container()
                            : Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 30.0,
                                          child: Checkbox(
                                            value: agreePersonalData,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                agreePersonalData = value!;
                                              });
                                            },
                                            activeColor: Color(0xff5669FF),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Text(
                                            'Remember Me',
                                            style: TextStyle(
                                                color: Color(0xff120D26),
                                                fontSize: 14.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    ForgotpasswordScreen()));
                                      },
                                      child: Text(
                                        'Remember Me',
                                        style: TextStyle(
                                            color: Color(0xff120D26),
                                            fontSize: 14.0),
                                      ),
                                    ),

                                    // ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    ButtonAuth(
                      colour: Colors.transparent,
                      backgroundColour: Color(0xff54BA64),
                      textColour: Colors.white,
                      onTap: () {},
                      title: 'Login',
                      title2: 'Register',
                      isCheck: _isLogin,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'OR',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 42,
                    ),
                    Column(
                      children: [
                        ButtonAuth(
                          colour: Color(0xffEDE5E5),
                          backgroundColour: Colors.white,
                          textColour: Colors.black,
                          onTap: () {},
                          icon: Icons.person,
                          title: 'Login with Google',
                          title2: 'Register with Google',
                          isCheck: _isLogin,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ButtonAuth(
                          colour: Color(0xffEDE5E5),
                          backgroundColour: Colors.white,
                          textColour: Colors.black,
                          onTap: () {},
                          icon: Icons.person,
                          title: 'Login with Facebook',
                          title2: 'Register with Facebook',
                          isCheck: _isLogin,
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin
                                  ? 'Nếu bạn có tài khoản thì hãy'
                                  : 'Nếu bạn chưa có tài khoản?',
                              style: TextStyle(
                                  //if false => false else true
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin ? 'Đăng nhập' : 'Đăng ký',
                                    style: TextStyle(
                                        color: Color(0xff1977F3),
                                        fontSize: 16)))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
