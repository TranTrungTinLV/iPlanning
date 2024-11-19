import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:uuid/uuid.dart';

Future<List<String>> uploadImageToStorage(
    List<Uint8List> images, String childName, bool isPost) async {
  List<String> imageUrls = [];
  for (var image in images) {
    String imageId = Uuid().v4().split('-')[0];
    Reference imageRef =
        storageInstance.ref().child(childName).child('$imageId.png');
    if (isPost) {
      imageRef = imageRef.child("$imageId"); // Cập nhật tham chiếu với id mới
    }
    try {
      await imageRef.putData(image);
      String dowloadUrl = await imageRef.getDownloadURL();

      imageUrls.add(dowloadUrl);
    } catch (e) {
      print("Failed to uploadImage ${e}");
    }
    print("All upload Urls: ${imageUrls}");
  }
  return imageUrls;
}
