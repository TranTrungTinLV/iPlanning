import 'dart:math';

import 'package:flutter/material.dart';

class Invitewithfriends extends StatelessWidget {
  const Invitewithfriends({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.03,
        horizontal: screenWidth * 0.04,
      ),
      padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.03, horizontal: screenWidth * 0.05),
      decoration: BoxDecoration(
        color: const Color(0xffD6FEFF),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      width: screenWidth,
      height: screenHeight * 0.2,
      child: ClipRRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invite Your Friend',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Gửi đây 100k',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.015),
                    decoration: BoxDecoration(
                        color: Color(0xff00F8FF),
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.02)),
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.012,
                      horizontal: screenWidth * 0.04,
                    ),
                    child: Text(
                      'Invite',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              widthFactor: 0.65, // Giới hạn chiều rộng
              heightFactor: 0.9, // Giới hạn chiều cao
              child: Transform.rotate(
                angle: -pi / 6,
                child: Container(
                  width: screenWidth * 0.4,
                  // height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/logo_invite.png'),
                    fit: BoxFit.contain,
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
