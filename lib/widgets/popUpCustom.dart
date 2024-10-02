import 'package:flutter/material.dart';

class PopupCustom extends StatelessWidget {
  const PopupCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text('Task List'),
        ),
        Container(
          child: Text('Budget List'),
        ),
        Container(
          child: Text('Guest List'),
        )
      ],
    );
  }
}
