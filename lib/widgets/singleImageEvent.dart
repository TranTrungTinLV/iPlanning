import 'package:flutter/material.dart';

class SingleImageEvents extends StatelessWidget {
  const SingleImageEvents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(color: Colors.amberAccent),
    );
  }
}
