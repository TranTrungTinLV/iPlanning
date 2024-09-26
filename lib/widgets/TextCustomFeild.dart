import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  TextFieldCustom(
      {super.key,
      required this.title,
      this.keyboardType = TextInputType.name,
      this.focusNode,
      this.labelText,
      this.controller,
      this.maxLine,
      this.minLine,
      this.radius,
      this.readonly = false});

  final String title;
  int? maxLine;
  int? minLine;
  final TextInputType? keyboardType;
  TextEditingController? controller;
  bool readonly;
  String? labelText;
  FocusNode? focusNode;
  double? radius;
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLine,
      minLines: minLine,
      focusNode: focusNode,
      keyboardType: keyboardType,
      controller: controller,
      readOnly: readonly,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 4.0),
        ),
        hintText: title,
        labelText: title,
      ),
    );
  }
}
