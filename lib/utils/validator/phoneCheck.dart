import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iplanning/consts/firebase_const.dart';

Future<bool> isPhoneNumberUnique(String phoneNumber) async {
  try {
    QuerySnapshot query = await firestoreInstance
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Lỗi khi kiểm tra số điện thoại: $e",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return false;
  }
}
