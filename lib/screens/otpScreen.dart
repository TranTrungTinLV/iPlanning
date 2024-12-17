import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/screens/loading_manager.dart';
import 'package:iplanning/screens/mainScreen/homeScreens.dart';
import 'package:iplanning/services/auth.service.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String sentOtp;

  OtpScreen({Key? key, required this.phoneNumber, required this.sentOtp})
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? _otpCode;
  bool _isResendEnabled = false;
  int _resendCooldown = 30;
  Timer? _resendTimer;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _resendOtp() {
    AuthenticationService()
        .sendOtpWithVoiceCall(widget.phoneNumber, widget.sentOtp);
    _startResendCooldown();
  }

  void _startResendCooldown() {
    setState(() {
      _isResendEnabled = false;
      _resendCooldown = 30;
    });

    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendCooldown > 0) {
        setState(() {
          _resendCooldown--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isResendEnabled = true;
        });
      }
    });
  }

  void _verifyOtp(String inputOtp, String sentOtp, String phoneNumber) async {
    if (inputOtp.isNotEmpty && inputOtp.length == 6) {
      _showLoading(true);
      try {
        bool isVerified = await AuthenticationService()
            .verifyOtp(inputOtp, sentOtp, phoneNumber);
        _showLoading(false);
        if (isVerified) {
          UserModel? user = await AuthenticationService().getUserData();
          if (user != null && user.isVerify) {
            print(
                'Người dùng đã được xác minh: ${user.name}, isVerify: ${user.isVerify}');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Homescreens()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Xác minh OTP không thành công.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mã OTP không hợp lệ.')),
          );
        }
      } catch (e) {
        print('Lỗi khi xác minh OTP: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Đã xảy ra lỗi trong quá trình xác minh. Vui lòng thử lại.')),
        );
      } finally {
        _showLoading(false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập mã OTP hợp lệ.')),
      );
    }
  }

  void _showLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập mã OTP'),
        centerTitle: true,
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (code) {
                  setState(() {
                    _otpCode = code;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Nhập mã OTP',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _verifyOtp(_otpCode!, widget.sentOtp, widget.phoneNumber);
                },
                child: Text('Xác minh'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _isResendEnabled ? _resendOtp : null,
                child: Text(_isResendEnabled
                    ? 'Gửi lại mã'
                    : 'Gửi lại mã sau ${_resendCooldown}s'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
