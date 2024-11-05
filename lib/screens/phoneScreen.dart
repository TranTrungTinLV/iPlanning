import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/screens/mainScreen/LoginScreen.dart';
import 'package:iplanning/screens/otpScreen.dart';
import 'package:iplanning/services/auth.dart';
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

  void _startPhoneVerification() {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isNotEmpty) {
      // Kiểm tra nếu số điện thoại bắt đầu với số 0, bỏ số 0 và thay thế bằng 84 (mã quốc gia Việt Nam)
      if (phoneNumber.startsWith('0')) {
        phoneNumber = '84' + phoneNumber.substring(1); // Bỏ số 0 và thêm mã 84
      }

      // Gửi OTP qua cuộc gọi với số điện thoại đã được chuẩn hóa
      _sendOtpToBackend(phoneNumber);
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

    // Chuyển sang OtpScreen để nhập OTP
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => OtpScreen(
          phoneNumber: phoneNumber,
          sentOtp: generatedOtp!, // Truyền OTP đã tạo sang OtpScreen
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
