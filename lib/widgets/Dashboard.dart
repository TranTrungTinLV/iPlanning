import 'dart:ui';

import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  TopBar({super.key, required this.drawer});
  final void Function() drawer;
  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.dashboard, size: 30, color: Colors.white),
          onPressed: widget.drawer,
        ),
        Column(
          children: const [
            Text(
              'Current Location',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
            ),
            Text(
              'Ho Chi Minh, VN',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xffF4F4FE),
              ),
            ),
          ],
        ),
        IconButton(
          icon: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                ),
              ),
              const Icon(Icons.notifications, color: Colors.white, size: 24),
            ],
          ),
          onPressed: () {
            print('hello');
          },
        ),
      ],
    );
  }
}
