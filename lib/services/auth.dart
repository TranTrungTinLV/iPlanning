import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/utils/authExceptionHandler.dart';

class AuthenticationService {
  final _firebase = FirebaseAuth.instance;
  final User? user = authInstance.currentUser;

  Future<AuthStatus> creatAccount({
    required String email,
    required String password,
    required String name,
    // required String uid,
    String? country,
    String? phoneNumber,
    File? avatars,
    File? newAvatars,
  }) async {
    AuthStatus status;
    try {
      UserCredential userCredentials = await _firebase
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredentials.user!.uid;

      // Tạo một map để lưu trữ dữ liệu người dùng
      Map<String, dynamic> userData = {
        'email': email,
        'uid': uid,
        'name': name,
        'country': country,
        'phone': phoneNumber,
        'newAvatars': null,
        'avatars': null, // Default value
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
      await FirebaseFirestore.instance
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
    required String email,
  }) async {
    AuthStatus status;
    try {
      // Query Firestore to check if the email exists
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: email)
          .get();

      if (query.docs.isNotEmpty) {
        await _firebase.sendPasswordResetEmail(email: email);
        Fluttertoast.showToast(
            msg: "Please reset link sent! Check your email",
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
            msg: "Email not found. Please register an account.",
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
      if (user == null) {
        // Handle trường hợp user chưa đăng nhập
        return null;
      }
      String uid = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

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

  Future<void> updateUser(UserModel userModel, {File? newAvatars}) async {
    String uid = user!.uid;

    if (newAvatars != null) {
      final storageRef =
          storageInstance.ref().child('user-image').child('${user!.uid}.png');
      await storageRef.putFile(newAvatars);
      final imageUrl = await storageRef.getDownloadURL();
      userModel.newAvatars = imageUrl;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(userModel.toJson());
  }
}
