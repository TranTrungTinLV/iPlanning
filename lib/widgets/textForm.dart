import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  TextForm({
    super.key,
    required bool isLogin,
    required this.valueUser,
    required this.icon,
    required this.title,
    required this.validator,
    this.obscureText = false,
    this.keyboardType,
    required this.onSaved,
  }) : _isLogin = isLogin;

  final bool _isLogin;
  String valueUser;
  final IconData icon;
  final String title;
  final String? Function(String?) validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: keyboardType,
          autocorrect: false,
          validator: validator,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: title,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            labelText: title,
            fillColor: Colors.white,
          ),
          onSaved: onSaved,
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
