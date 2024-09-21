import 'package:flutter/material.dart';

class CategoriesUI extends StatelessWidget {
  const CategoriesUI(
      {super.key,
      this.colour = Colors.white,
      this.textColour = Colors.black,
      required this.icons,
      this.iconColour = Colors.white,
      required this.titleCate});
  final Color? colour;
  final Color? textColour;
  final String titleCate;
  final IconData icons;
  final Color iconColour;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 43, horizontal: 11),
      height: 42,
      width: 100,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        )
      ], color: colour, borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icons,
                color: iconColour,
                size: 25,
              ),
              SizedBox(
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
