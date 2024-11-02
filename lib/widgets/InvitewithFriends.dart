import 'dart:math';

import 'package:flutter/material.dart';

class Invitewithfriends extends StatelessWidget {
  const Invitewithfriends({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xffD6FEFF),
          borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      child: ClipRRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Invite Your Friend',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const Text(
                  'Gửi đây 100k',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                        color: const Color(0xff00F8FF),
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Invite',
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
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
                  width: MediaQuery.of(context).size.width * 0.45,
                  // height: 200,
                  decoration: const BoxDecoration(
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
