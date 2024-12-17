import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/screens/mainScreen/LoginScreen.dart';
import 'package:iplanning/screens/otpScreen.dart';
import 'package:iplanning/services/auth.service.dart';
import 'package:iplanning/utils/validator/phoneCheck.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';

class PhoneScreen extends StatefulWidget {
  final String? phoneNumber;

  PhoneScreen({Key? key, this.phoneNumber}) : super(key: key);

  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  late TextEditingController _phoneController;
  String? generatedOtp; // Lưu trữ OTP đã tạo để xác minh sau

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.phoneNumber ?? '');
  }

  void _startPhoneVerification() async {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isNotEmpty) {
      if (phoneNumber.startsWith('0')) {
        phoneNumber = '84' + phoneNumber.substring(1);
      }
      bool phoneExists = await isPhoneNumberUnique(phoneNumber);
      if (phoneExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Số điện thoại này đã tồn tại trong hệ thống.')),
        );
      } else {
        _sendOtpToBackend(phoneNumber);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập số điện thoại hợp lệ.')),
      );
    }
  }

  void _sendOtpToBackend(String phoneNumber) {
    generatedOtp = generateOtp();
    print('Generated OTP: $generatedOtp');
    AuthenticationService().sendOtpWithVoiceCall(phoneNumber, generatedOtp!);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => OtpScreen(
          phoneNumber: phoneNumber,
          sentOtp: generatedOtp!,
        ),
      ),
    );
  }

  String generateOtp() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            authInstance.signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Loginscreen()),
            );
          },
        ),
        title: Text('Nhập Số Điện Thoại'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.phoneNumber != null
                ? TextFieldCustom(
                    controller: _phoneController,
                    title: widget.phoneNumber!,
                    keyboardType: TextInputType.number,
                  )
                : TextFieldCustom(
                    controller: _phoneController,
                    title: 'Phone Number',
                    keyboardType: TextInputType.number,
                  ), //phone number

            SizedBox(height: 20),
            GestureDetector(
              onTap: _startPhoneVerification,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Color(0xff3D56F0),
                ),
                child: Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
