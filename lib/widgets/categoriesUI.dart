import 'package:flutter/material.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 11),
      height: 42,
      width: 100,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            )
          ],
          color: colour,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              // Icon(
              //   icons,
              //   color: iconColour,
              //   size: 25,
              // ),
              const SizedBox(
                width: 5,
              ),
              Text(
                titleCate,
                style: TextStyle(color: textColour, fontSize: 15),
              )
            ],
          ),
        ],
      ),
    );
  }
}
