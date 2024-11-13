import 'package:flutter/material.dart';

class ButtonAuth extends StatelessWidget {
  const ButtonAuth({
    super.key,
    required this.colour,
    required this.backgroundColour,
    required this.textColour,
    required this.onTap,
    this.iconColor,
    this.icon,
    required this.title,
    this.title2,
    required this.isCheck,
  });
  final Color colour;
  final Color? iconColor;
  final Color backgroundColour;
  final Color textColour;
  final void Function() onTap;
  final dynamic icon;
  final String title;
  final String? title2;
  final bool isCheck;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 60),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: backgroundColour,
          border: Border.all(
            strokeAlign: 1.0,
            color: colour,
          ),
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: icon != null
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            if (icon != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildIcon(),
              ),
            icon != null
                ? Expanded(
                    child: Text(
                      isCheck ? title2! : title,
                      style: TextStyle(
                        color: textColour,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                  )
                : Text(
                    isCheck ? title2! : title,
                    style: TextStyle(
                      color: textColour,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
            if (icon != null) const SizedBox(width: 20), // Space for symmetry
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon is String) {
      return Image.network(
        icon,
        fit: BoxFit.cover,
        width: 35,
        height: 30,
      );
    } else if (icon is IconData) {
      return Icon(
        icon,
        size: 30,
        color: iconColor,
      );
    } else {
      return Container();
    }
  }
}
