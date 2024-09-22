import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text('Notification'),
      actions: [
        Icon(
          Icons.more_vert,
          size: 22,
        ),
        SizedBox(
          width: 22,
        )
      ],
    ));
  }
}
