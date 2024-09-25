import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  TextFieldCustom(
      {super.key,
      required this.title,
      this.keyboardType = TextInputType.name,
      this.focusNode,
      this.labelText,
      this.controller,
      this.readonly = false});

  final String title;

  final TextInputType? keyboardType;
  TextEditingController? controller;
  bool readonly;
  String? labelText;
  FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      keyboardType: keyboardType,
      controller: controller,
      readOnly: readonly,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: title,
        labelText: title,
      ),
    );
  }
}
