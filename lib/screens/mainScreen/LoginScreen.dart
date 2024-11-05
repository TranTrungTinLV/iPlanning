import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/screens/mainScreen/homeScreens.dart';
import 'package:iplanning/screens/forgotpassword.dart';
import 'package:iplanning/screens/loading_manager.dart';
import 'package:iplanning/screens/phoneScreen.dart';

import 'package:iplanning/utils/authExceptionHandler.dart';
import 'package:iplanning/widgets/ImagePicker.dart';
import 'package:iplanning/widgets/bannerWiget.dart';
import 'package:iplanning/widgets/buttonAuth.dart';
import 'package:iplanning/services/auth.dart';
import 'package:iplanning/widgets/textForm.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  var _enterusername = '';
  final _formKey = GlobalKey<FormState>();
  String _enteremail = '';
  String _enterpassword = '';
  bool _isLogin = false;
  bool _isLoading = false;
  bool agreePersonalData = false;
  String _repeatpasword = '';

  final _authService = AuthenticationService();
  void _onsubmit() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();

      _showLoading(true);
      try {
        if (!_isLogin) {
          await _handleLogin();
        } else {
          //TODO
          await _handleSignUp();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {}
        _showErrorSnackBar(
          AuthExceptionHandler.generateErrorMessage(
              AuthExceptionHandler.handleAuthException(e)),
        );
      } finally {
        _showLoading(false);
      }
    }
  }

  void _showLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> _handleLogin() async {
    print("Đăng nhập");
    AuthStatus signInStatus = await _authService.login(
      email: _enteremail,
      password: _enterpassword,
    );

    if (signInStatus == AuthStatus.successful) {
      print(
          "Người dùng đã đăng nhập: ${FirebaseAuth.instance.currentUser?.uid}");
      UserModel? userModel = await _authService.getUserData();
      if (userModel != null) {
        print(
            'Dữ liệu người dùng: ${userModel.toJson()}'); // Kiểm tra toàn bộ dữ liệu người dùng

        if (userModel.isVerify == false) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => PhoneScreen(
                      phoneNumber: userModel.phone,
                    )),
            (route) => false,
          );
        } else {
          _navigateToHome();
        }
      }
    } else {
      _showErrorSnackBar(
        AuthExceptionHandler.generateErrorMessage(signInStatus),
      );
    }
  }

  Future<void> _handleSignUp() async {
    AuthStatus signUpStatus = await _authService.creatAccount(
      email: _enteremail,
      password: _enterpassword,
      name: _enterusername,
    );
    if (signUpStatus == AuthStatus.successful) {
      print(
          "Người dùng đã đăng nhập: ${FirebaseAuth.instance.currentUser?.uid}");
      UserModel? userModel = await _authService.getUserData();

      if (userModel != null) {
        print(
            'Dữ liệu người dùng: ${userModel.toJson()}'); // Kiểm tra toàn bộ dữ liệu người dùng

        if (userModel.isVerify == false) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => PhoneScreen(
                      phoneNumber: userModel.phone ?? null,
                    )),
            (route) => false,
          );
        } else {
          _navigateToHome();
        }
      }
    } else {
      _showErrorSnackBar(
        AuthExceptionHandler.generateErrorMessage(signUpStatus),
      );

      return;
    }
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Homescreens()),
      (route) => false,
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        elevation: 3.0,
        content: Container(
          padding: const EdgeInsets.all(8.0),
          height: 80.0,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Text(
            message,
            style: const TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: authInstance.authStateChanges(),
        builder: (context, snapshot) {
          return LoadingManager(
            isLoading: _isLoading,
            child: Bannerwiget(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(horizontal: 28),
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
                                        colors: const [
                                          Color(0xff5669FF),
                                          Color(0xff00F8FF)
                                        ],
                                        style: const TextStyle(
                                            fontSize: 48.0,
                                            fontFamily: 'Italiana'),
                                      ),
                                    ),
                              const SizedBox(
                                height: 50,
                              ),
                              const SizedBox(
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
                                        if (_repeatpasword != _enterpassword) {
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
                                              SizedBox(
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
                                                      const Color(0xff5669FF),
                                                ),
                                              ),
                                              GestureDetector(
                                                child: const Text(
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
                                                          const ForgotpasswordScreen()));
                                            },
                                            child: const Text(
                                              'Remember Me',
                                              style: TextStyle(
                                                  color: Color(0xff120D26),
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          ButtonAuth(
                            colour: Colors.transparent,
                            backgroundColour: const Color(0xff3D56F0),
                            textColour: Colors.white,
                            onTap: _onsubmit,
                            title: 'Login',
                            title2: 'Register',
                            isCheck: _isLogin,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'OR',
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 42,
                          ),
                          Column(
                            children: [
                              ButtonAuth(
                                colour: const Color(0xffEDE5E5),
                                backgroundColour: Colors.white,
                                textColour: Colors.black,
                                onTap: () {},
                                icon: Icons.person,
                                title: 'Login with Google',
                                title2: 'Register with Google',
                                isCheck: _isLogin,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ButtonAuth(
                                colour: const Color(0xffEDE5E5),
                                backgroundColour: Colors.white,
                                textColour: Colors.black,
                                onTap: () {},
                                icon: Icons.person,
                                title: 'Login with Facebook',
                                title2: 'Register with Facebook',
                                isCheck: _isLogin,
                              ),
                              const SizedBox(
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
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isLogin = !_isLogin;
                                        });
                                      },
                                      child: Text(
                                          _isLogin ? 'Đăng nhập' : 'Đăng ký',
                                          style: const TextStyle(
                                              color: Color(0xff1977F3),
                                              fontSize: 16)))
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
