import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreen extends StatefulWidget {
  CallScreen(
      {super.key,
      required this.callID,
      required this.userID,
      required this.userName});
  final String callID;
  final String userID;
  final String userName;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID: int.parse("${dotenv.env['APP_ID']}"),
        appSign: "${dotenv.env['APP_SIGN']}",
        callID: widget.callID,
        userID: widget.userID,
        userName: widget.userName,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall());
  }
}
