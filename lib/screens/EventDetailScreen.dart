import 'dart:ui';

import 'package:flutter/material.dart';

class Eventdetailscreen extends StatelessWidget {
  const Eventdetailscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/event.png'),
                      repeat: ImageRepeat.repeatX,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      // opacity: 0.9,
                    ),
                    gradient: LinearGradient(
                        colors: [Colors.black45, Colors.black45]))),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                width: MediaQuery.of(context).size.width,
              )),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              width: MediaQuery.of(context).size.width,
              // color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_back,
                            color: Colors.white, size: 24),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.bookmark,
                            color: Colors.white, size: 24),
                      ],
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
