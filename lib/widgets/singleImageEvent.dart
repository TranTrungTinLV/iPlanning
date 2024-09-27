import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class SingleImageEvents extends StatelessWidget {
  SingleImageEvents({
    super.key,
    required this.imageUrl,
  });
  final Uint8List imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
