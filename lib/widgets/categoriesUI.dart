import 'package:flutter/material.dart';
import 'package:iplanning/utils/validator/capitalize.dart';

class CategoriesUI extends StatelessWidget {
  CategoriesUI(
      {super.key,
      this.colour = Colors.white,
      this.textColour = Colors.white,
      this.icons,
      this.iconColour = Colors.white,
      required this.titleCate});
  final Color? colour;
  final Color? textColour;
  final String titleCate;
  final IconData? icons;
  final Color iconColour;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 11),
      height: screenHeight * 0.11,
      width: screenWidth * 0.3,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: screenWidth * 0.03,
              spreadRadius: 2.0,
            )
          ],
          color: colour,
          borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.04))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(width: screenWidth * 0.01),
              Text(
                capitalize(titleCate),
                style: TextStyle(
                    color: textColour,
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )
            ],
          ),
        ],
      ),
    );
  }
}
