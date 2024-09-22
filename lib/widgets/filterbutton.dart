import 'dart:ui';

import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 32,
          width: 75,
          // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              // color: Colors.red,
              ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                height: 32,
                width: 75,
                decoration: const BoxDecoration(
                  color: Colors.white10,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            print('filter');
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  Icons.filter_list,
                  size: 24,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  'Filter',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.03),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
