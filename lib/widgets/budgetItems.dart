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
      color: isCoulors! ? Color(0xffD6BBFB) : Color(0xff9E77ED),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                ),
              ),
              SizedBox()
            ],
          )
        ],
      ),
    );
  }
}
