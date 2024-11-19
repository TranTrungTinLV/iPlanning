import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/utils/authExceptionHandler.dart';
import 'package:iplanning/widgets/buttonAuth.dart';
import 'package:iplanning/services/auth.service.dart';
import 'package:iplanning/widgets/textForm.dart';

class ForgotpasswordScreen extends StatefulWidget {
  const ForgotpasswordScreen({super.key});

  @override
  State<ForgotpasswordScreen> createState() => _ForgotpasswordScreenState();
}

class _ForgotpasswordScreenState extends State<ForgotpasswordScreen> {
  String _enterPhone = '';
  String _enterNewPassword = '';
  String _otp = '';
  String? code;
  final _authService = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  bool _isPhoneVerified = false;

  Future passwordReset() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();

      try {
        String generateOtp() {
          final random = Random();
          return (random.nextInt(900000) + 100000).toString();
        }

        code = generateOtp();
        AuthStatus status = await _authService.forgotPassword(
            phoneNumber: _enterPhone, code: code!);
        await _authService.verifyOtp(_otp, code!, _enterPhone);
        if (status != AuthStatus.successful) {
          String errorMessage =
              AuthExceptionHandler.generateErrorMessage(status);

          return;
        }
        setState(() {
          _isPhoneVerified = true;
        });
        // showDialog(
        //   context: context,
        //   builder: (ctx) {
        //     return const AlertDialog(
        //       content: Text('Please reset link sent! Check your email'),
        //     );
        //   },
        // );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Authentication failed. ')));
      }
    }
  }

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
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Form(
                    key: _formKey,
                    child: !_isPhoneVerified
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextForm(
                                isLogin: false,
                                valueUser: _enterPhone,
                                icon: Icons.phone,
                                title: 'Your Number',
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.length < 10) {
                                    return 'số điện thoại không hợp lệ';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enterPhone = value!;
                                },
                              )

                              // TextForm(
                              //   isLogin: false,
                              //   valueUser: _enterNewPassword,
                              //   icon: Icons.password,
                              //   title: 'Enter Password',
                              //   validator: (value) {
                              //     if (value == null || value.length < 6) {
                              //       return 'Mật khẩu phải ít nhất 6 ký tự';
                              //     }
                              //     return null;
                              //   },
                              //   onSaved: (value) {
                              //     _enterNewPassword = value!;
                              //   },
                              // ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.password),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    hintText: 'Enter pass',
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade400),
                                    filled: true,
                                    labelText: 'Enter Passs',
                                    fillColor: Colors.white,
                                  ),
                                  onSaved: (value) {
                                    _enterNewPassword = value!;
                                  },
                                ),
                                SizedBox(height: 15.0),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.password),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    hintText: 'Enter OTP',
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade400),
                                    filled: true,
                                    labelText: 'Enter OTP',
                                    fillColor: Colors.white,
                                  ),
                                  onSaved: (value) {
                                    _otp = value!;
                                  },
                                ),
                              ]),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        ButtonAuth(
                          colour: const Color(0xffEDE5E5),
                          backgroundColour: const Color(0xff54BA64),
                          textColour: Colors.white,
                          onTap: passwordReset,
                          title: !_isPhoneVerified ? 'Check' : 'Submit',
                          isCheck: false,
                        ),
                        if (_isPhoneVerified)
                          GestureDetector(
                            child: Text('Quay lại'),
                            onTap: () {
                              setState(() {
                                _isPhoneVerified = !_isPhoneVerified;
                              });
                            },
                          )
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
