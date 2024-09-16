import 'package:flutter/material.dart';

class AuthUser extends StatefulWidget {
  const AuthUser({super.key});

  @override
  State<AuthUser> createState() => _AuthUserState();
}

class _AuthUserState extends State<AuthUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Hi')),
    );
  }
}
