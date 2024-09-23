import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUserPicker extends StatefulWidget {
  ImageUserPicker({super.key, required this.onPickImage});
  final void Function(File pickedImage) onPickImage;
  @override
  State<ImageUserPicker> createState() => _ImageUserPickerState();
}

class _ImageUserPickerState extends State<ImageUserPicker> {
  File? pickImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    if (pickedImage == null) return null;
    setState(() {
      pickImageFile = File(pickedImage.path);
    });
    widget.onPickImage(pickImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
              foregroundImage:
                  pickImageFile != null ? FileImage(pickImageFile!) : null,
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}
