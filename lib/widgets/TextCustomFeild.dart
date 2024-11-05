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
      this.hintStyle,
      this.bottom,
      this.validator,
      this.readonly = false,
      this.onSaved,
      this.textAlign = TextAlign.start,
      this.onChanged});

  final String title;
  int? maxLine;
  TextStyle? hintStyle;
  int? minLine;
  final TextInputType? keyboardType;
  TextEditingController? controller;
  bool readonly;
  String? labelText;
  FocusNode? focusNode;
  TextAlign textAlign;
  double? radius;
  double? bottom;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;

  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottom ?? 0.0),
      child: TextFormField(
        textAlign: textAlign,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        maxLines: maxLine,
        minLines: minLine,
        focusNode: focusNode,
        keyboardType: keyboardType,
        controller: controller,
        readOnly: readonly,
        decoration: InputDecoration(
          hintStyle: hintStyle,
          
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
