import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/utils/authExceptionHandler.dart';
import 'package:iplanning/widgets/button.dart';
import 'package:iplanning/services/auth.dart';
import 'package:iplanning/widgets/textForm.dart';

class ForgotpasswordScreen extends StatefulWidget {
  const ForgotpasswordScreen({super.key});

  @override
  State<ForgotpasswordScreen> createState() => _ForgotpasswordScreenState();
}

class _ForgotpasswordScreenState extends State<ForgotpasswordScreen> {
  var _enteremail = '';
  final _authService = AuthenticationService();
  final _formKey = GlobalKey<FormState>();

  Future passwordReset() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        //TODO: QuerySnapshot query = await FirebaseFirestore.instance.collection('users').where("e-mail", isEqualTo: email).get(); if (query.docs.isNotEmpty) { // Email is already used... }

        AuthStatus ForgotStatus =
            await _authService.forgotPassword(email: _enteremail);

        if (ForgotStatus != AuthStatus.successful) {
          String errorMessage =
              AuthExceptionHandler.generateErrorMessage(ForgotStatus);
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
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Text(
                      errorMessage,
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.white),
                    ))),
          );
          return;
        }
        showDialog(
          context: context,
          builder: (ctx) {
            return const AlertDialog(
              content: Text('Please reset link sent! Check your email'),
            );
          },
        );
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextForm(
                          isLogin: false,
                          valueUser: _enteremail,
                          icon: Icons.email,
                          title: 'Your email',
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
                      ],
                    ),
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
