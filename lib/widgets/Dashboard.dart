import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iplanning/screens/map1.dart';
import 'package:iplanning/screens/notification.dart';

class TopBar extends StatefulWidget {
  TopBar(
      {super.key,
      required this.drawer,
      required this.counter_notifi,
      this.eventId,
      required this.getPicture,
      required this.location});
  final void Function() getPicture;
  final void Function() drawer;
  String location;
  String? eventId;
  final int counter_notifi;
  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final counter = widget.counter_notifi < 0 ? 0 : widget.counter_notifi;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.dashboard,
              size: screenWidth * 0.08, color: Colors.white),
          onPressed: widget.drawer,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Vị trí Hiện Tại',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w300),
              ),
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
                child: (widget.location.isNotEmpty)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth * 0.45,
                            child: Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              widget.location,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffF4F4FE),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            size: screenWidth * 0.03,
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
                            style: TextStyle(
                                color: const Color.fromRGBO(244, 67, 54, 1)),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            size: screenWidth * 0.04,
                            color: Colors.red,
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
              // Vòng tròn nền mờ
              Container(
                width: screenWidth * 0.09,
                height: screenWidth * 0.09,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.045),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),
              ),
              // Icon thông báo
              Icon(
                Icons.notifications,
                color: Colors.white,
                size: screenWidth * 0.06,
              ),

              if (counter > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.012),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${counter}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.02,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
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
