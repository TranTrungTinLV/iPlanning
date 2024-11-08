import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iplanning/screens/map1.dart';
import 'package:iplanning/screens/notification.dart';

class TopBar extends StatefulWidget {
  TopBar(
      {super.key,
      required this.drawer,
      this.eventId,
      required this.getPicture,
      required this.location});
  final void Function() getPicture;
  final void Function() drawer;
  String location;
  String? eventId;
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
          children: [
            Text(
              'Current Location',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
            ),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Map1Screen(
                        location: widget.location,
                      ),
                    ));
                if (result != null && result is String) {
                  setState(() {
                    widget.location = result;
                  });
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: (widget.location != null)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            widget.location,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffF4F4FE),
                            ),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            size: 12,
                            color: Colors.white,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Vui Lòng chọn',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => NotificationScreen(
                          getPicture: widget.getPicture,
                        )));
          },
        ),
      ],
    );
  }
}
