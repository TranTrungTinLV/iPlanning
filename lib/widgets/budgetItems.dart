import 'package:flutter/material.dart';

class budgetItems extends StatelessWidget {
  const budgetItems({
    super.key,
    required this.title,
    required this.isCoulors,
  });
  final String title;
  final bool isCoulors;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: isCoulors ? Colors.red.shade700 : Colors.yellow.shade700,
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
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox()
            ],
          )
        ],
      ),
    );
  }
}
