import 'package:flutter/material.dart';

class budgetItems extends StatelessWidget {
  budgetItems({
    super.key,
    required this.title,
    this.isCoulors = false,
  });
  final String title;
  bool? isCoulors;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: isCoulors! ? Colors.red.shade700 : Colors.yellow.shade700,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 18.0,
                    color: isCoulors! ? Colors.white : Colors.black),
              ),
              SizedBox()
            ],
          )
        ],
      ),
    );
  }
}
