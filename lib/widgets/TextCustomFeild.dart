import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom({
    super.key,
    required this.title,
    this.keyboardType = TextInputType.name,
  });

  final String title;

  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: title,
        labelText: title,
      ),
    );
  }
}
