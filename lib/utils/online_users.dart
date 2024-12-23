import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updateUserOnlineStatus(bool isOnline) async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'isOnline': isOnline});
      print('Cập nhật isOnline thành công: $isOnline');
    } else {
      print('Người dùng không tồn tại, không thể cập nhật isOnline');
    }
  } catch (e) {
    print('Lỗi khi cập nhật isOnline: $e');
  }
}
