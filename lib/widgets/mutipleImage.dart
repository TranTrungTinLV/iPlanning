import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iplanning/widgets/singleImageEvent.dart';

class MutipleImage extends StatefulWidget {
  MutipleImage({
    super.key,
    required this.images,
  });
  // final File? pickImageFile;
  final List<Uint8List> images;

  @override
  State<MutipleImage> createState() => _MutipleImageState();
}

class _MutipleImageState extends State<MutipleImage> {
  void addImage(Uint8List url) {
    widget.images.add(url);
  }

  void removeImage(Uint8List url) {
    widget.images.remove(url);
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 90, maxWidth: 800);
    if (pickedImage == null) return null;
    final imageBytes = await File(pickedImage.path).readAsBytes();

    setState(() {
      addImage(imageBytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          widget.images.isEmpty
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Center(child: Text('Vui lòng chọn ảnh')),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: MemoryImage(
                            widget.images[0],
                          ),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(20)),
                ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(right: 10, top: 10),
            child: Text("${widget.images.length.toString()}/5"),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 10),
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  widget.images.isEmpty
                      ? Container(
                          // child: Text('No img'),
                          )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.images.map((img) {
                              return SingleImageEvents(imageUrl: img);
                            }).toList(),
                          ),
                        ),
                  GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height,
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.orange,
                        weight: 200,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
