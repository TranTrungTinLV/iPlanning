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
      this.bottom,
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
  double? bottom;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottom ?? 0.0),
      child: TextField(
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
      ),
    );
  }
}
