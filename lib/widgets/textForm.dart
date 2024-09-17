import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  TextForm({
    super.key,
    required bool isLogin,
    required this.valueUser,
    required this.icon,
    required this.title,
  }) : _isLogin = isLogin;

  final bool _isLogin;
  String valueUser;
  final IconData icon;
  final String title;
  // final String title2;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.name,
          autocorrect: false,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'name không hợp lệ';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: title,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            labelText: title,
            fillColor: Colors.white,
          ),
          onSaved: (value) {
            valueUser = value!;
          },
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
