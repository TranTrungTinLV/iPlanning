import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/user_models.dart';

import 'package:iplanning/utils/authExceptionHandler.dart';

import 'package:http/http.dart' as http;
import 'package:iplanning/utils/validator/phoneCheck.dart';

class AuthenticationService {
  final _firebase = authInstance;
  final User? user = authInstance.currentUser;

  Future<AuthStatus> creatAccount(
      {required String email,
      required String password,
      required String name,
      String? country,
      String? phoneNumber,
      File? avatars,
      List<String>? wishList,
      File? newAvatars,
      isVerify = false}) async {
    AuthStatus status;
    try {
      UserCredential userCredentials = await _firebase
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredentials.user!.uid;

      // Tạo một map để lưu trữ dữ liệu người dùng
      Map<String, dynamic> userData = {
        'email': email,
        'wishList': wishList,
        'uid': uid,
        'name': name,
        'country': country,
        'phone': phoneNumber,
        'newAvatars': null,
        'avatars': null, // Default value
        'isVerify': isVerify,
        'isOnline': false,
      };
      // String? imageUrl;
      if (avatars != null) {
        print(avatars);

        final storageRef = storageInstance
            .ref()
            .child('user-image')
            .child('${userCredentials.user!.uid}.png');

        await storageRef.putFile(avatars);
        final imageUrl = await storageRef.getDownloadURL();
        print('URL của ảnh sau khi tải lên: $imageUrl');

        userData['avatars'] = imageUrl;
      }
      await firestoreInstance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set(userData); // Lưu dữ liệu bao gồm avatar

      status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      status = AuthExceptionHandler.handleAuthException(e);
    }
    return status;
  }

  Future<AuthStatus> login({
    required String email,
    required String password,
  }) async {
    AuthStatus status;
    try {
      UserCredential userCredentials = await _firebase
          .signInWithEmailAndPassword(email: email, password: password);
      status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      status = AuthExceptionHandler.handleAuthException(e);
    }
    return status;
  }

  Future<AuthStatus> forgotPassword({
    required String phoneNumber,
    required String code,
  }) async {
    AuthStatus status;
    try {
      QuerySnapshot query = await firestoreInstance
          .collection('users')
          .where("phone", isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        String uid = query.docs.first.id;
        // User user = await _firebase.currentUser!;
        // await user.updatePassword(newPassword);

        String name = query.docs.first["name"];
        print("Tên người dùng ${name}");

        await sendOtpWithVoiceCall(phoneNumber, code);
        Fluttertoast.showToast(
            msg: "Vui lòng đợi cuộc gọi",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade600,
            textColor: Colors.white,
            fontSize: 16.0);
        status = AuthStatus.successful;
      } else {
        // If the email does not exist, show an error message
        Fluttertoast.showToast(
            msg: "Không tìm thấy số điện thoại của bạn",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        status = AuthStatus.userNotFound;
      }
    } on FirebaseAuthException catch (e) {
      status = AuthExceptionHandler.handleAuthException(e);
    }
    return status;
  }

  Future<UserModel?> getUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return null;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        // Sử dụng factory constructor fromJson
        return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        // Fluttertoast.showToast(
        //     msg: "User not found",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);

        // return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error fetching user data: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
    }
    return null;
  }

  Future<UserModel?> getUserProfile(String uid) async {
    try {
      if (user == null) {
        return null;
      }
      final DocumentSnapshot userDoc =
          await firestoreInstance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // Sử dụng factory constructor fromJson
        return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {}
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error fetching user data: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
    }
    return null;
  }

  Future<void> updateUser(UserModel userModel, {File? newAvatars}) async {
    String uid = user!.uid;
    if (userModel.phone != null &&
        !(await isPhoneNumberUnique(userModel.phone!))) {
      Fluttertoast.showToast(
          msg: "Số điện thoại đã được sử dụng.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (newAvatars != null) {
      final storageRef =
          storageInstance.ref().child('user-image').child('${user!.uid}.png');
      await storageRef.putFile(newAvatars);
      final imageUrl = await storageRef.getDownloadURL();
      userModel.newAvatars = imageUrl;
    }
    await firestoreInstance
        .collection('users')
        .doc(uid)
        .update(userModel.toJson());
  }

  Future<void> sendOtpWithVoiceCall(String phoneNumber, String otp) async {
    String apiUrl = "${dotenv.env['API_STRINGGEE']}";
    String jwtToken = '${dotenv.env['STRINGEE_TOKEN']}';

    final Map<String, dynamic> payload = {
      "from": {
        "type": "external",
        "number": "${dotenv.env['PHONE_FROM']}",
        "alias": "Iplanning"
      },
      "to": [
        {"type": "external", "number": phoneNumber, "alias": phoneNumber}
      ],
      "actions": [
        {"action": "talk", "text": "Mã otp của bạn là $otp"}
      ],
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'X-STRINGEE-AUTH': jwtToken,
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print('Cuộc gọi OTP đã được thực hiện thành công.');
    } else {
      print('Lỗi khi thực hiện cuộc gọi OTP: ${response.body}');
    }
  }

  Future<bool> verifyOtp(
      String inputOtp, String sentOtp, String phoneNumber) async {
    if (inputOtp == sentOtp) {
      User? currentUser = _firebase.currentUser;
      if (currentUser != null) {
        try {
          await firestoreInstance
              .collection('users')
              .doc(currentUser.uid)
              .update({'isVerify': true, 'phone': phoneNumber});
          print('Cập nhật isVerify thành công cho user ${currentUser.uid}');
          return true;
        } catch (e) {
          print('Lỗi khi cập nhật isVerify: $e');
          return false;
        }
      }
    }
    return false;
  }
}
