import 'package:flutter/material.dart';

class budgetItems extends StatelessWidget {
  const budgetItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            child: Icon(Icons.place),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Food&Drink',
                style: TextStyle(fontSize: 14.0),
              ),
              Text(
                '1tr2',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    );
  }
}
