import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iplanning/screens/homeScreens.dart';
import 'package:iplanning/screens/forgotpassword.dart';
import 'package:iplanning/screens/loading_manager.dart';
import 'package:iplanning/utils/authExceptionHandler.dart';
import 'package:iplanning/widgets/ImagePicker.dart';
import 'package:iplanning/widgets/button.dart';
import 'package:iplanning/widgets/signup.dart';
import 'package:iplanning/widgets/textForm.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

final _firebase = FirebaseAuth.instance;

class Loginscreen extends StatefulWidget {
  Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  var _enterusername = '';
  final _formKey = GlobalKey<FormState>();
  var _enteremail = '';
  var _enterpassword = '';
  var _isLogin = false;
  var _isLoading = false;
  var agreePersonalData = false;
  var _repeatpasword = '';
  File? _selectedImage;
  final _authService = AuthenticationService();
  void _onsubmit() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      print("_selectedImage ${_selectedImage}");

      setState(() {
        _isLoading =
            true; 
      });
      try {
        if (!_isLogin) {
          AuthStatus signInStatus = await _authService.login(
            email: _enteremail,
            password: _enterpassword,
          );
          if (signInStatus == AuthStatus.successful) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Homescreens()),
              (route) => false,
            );
          }
          if (signInStatus != AuthStatus.successful) {
            String errorMessage =
                AuthExceptionHandler.generateErrorMessage(signInStatus);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  elevation: 3.0,
                  content: Container(
                      padding: EdgeInsets.all(8.0),
                      height: 80.0,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Text(
                        '${errorMessage}',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ))),
            );
            return;
          } else {}
        } else {
          //TODO
          AuthStatus signUpStatus = await _authService.creatAccount(
            email: _enteremail,
            password: _enterpassword,
            name: _enterusername,
            avatars: _selectedImage,
          );
          if (signUpStatus == AuthStatus.successful) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Homescreens()),
              (route) => false,
            );
          }
          if (signUpStatus != AuthStatus.successful) {
            String errorMessage =
                AuthExceptionHandler.generateErrorMessage(signUpStatus);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  elevation: 3.0,
                  content: Container(
                      padding: EdgeInsets.all(8.0),
                      height: 80.0,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Text(
                        '${errorMessage}',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ))),
            );

            return;
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          //  ..
        }
        String errorMessage = AuthExceptionHandler.generateErrorMessage(
            AuthExceptionHandler.handleAuthException(e));

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: Container(
                  padding: EdgeInsets.all(8.0),
                  height: 80.0,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Text(
                    'loi ${errorMessage}',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ))),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return LoadingManager(
                isLoading: _isLoading,
                child: Stack(
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
                              key: _formKey,
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
                                                fontSize: 48.0,
                                                fontFamily: 'Italiana'),
                                          ),
                                        ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  _isLogin
                                      ? Center(
                                          child: ImageUserPicker(
                                            onPickImage: (File pickedImage) {
                                              _selectedImage = pickedImage;
                                            },
                                          ),
                                        ) //phần của đăng ký
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
                                          keyboardType: TextInputType.name,
                                          icon: Icons.person,
                                          title: 'Full Name',
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                value.trim().isEmpty) {
                                              return "Vui Lòng Nhập Tên";
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _enterusername = value!;
                                          },
                                        )
                                      : Container(),
                                  TextForm(
                                    isLogin: _isLogin,
                                    valueUser: _enteremail,
                                    icon: Icons.email,
                                    title: 'email',
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty ||
                                          !value.contains('@')) {
                                        return 'email không hợp lệ';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enteremail = value!;
                                    },
                                  ),
                                  TextForm(
                                    isLogin: _isLogin,
                                    valueUser: _enterpassword,
                                    icon: Icons.password,
                                    title: 'password',
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null) {
                                        return "Mật khẩu tối thiểu phải 6";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enterpassword = value!;
                                    },
                                  ),
                                  _isLogin
                                      ? TextForm(
                                          isLogin: _isLogin,
                                          valueUser: _enterpassword,
                                          icon: Icons.password,
                                          obscureText: true,
                                          title: 'Confirm password',
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Nhập lại mật khẩu không hợp lệ';
                                            }
                                            if (_repeatpasword !=
                                                _enterpassword) {
                                              return 'Mật khẩu không khớp';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _repeatpasword = value!;
                                          },
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
                                                          agreePersonalData =
                                                              value!;
                                                        });
                                                      },
                                                      activeColor:
                                                          Color(0xff5669FF),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    child: Text(
                                                      'Remember Me',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff120D26),
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
                                onTap: _onsubmit,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          child: Text(
                                              _isLogin
                                                  ? 'Đăng nhập'
                                                  : 'Đăng ký',
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
                ));
          }),
    );
  }
}
