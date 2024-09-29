import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/widgets/details.dart';

class Eventdetailscreen extends StatelessWidget {
  Eventdetailscreen(
      {super.key,
      required this.uid,
      required this.titleEvent,
      required this.userName,
      required this.location,
      required this.startDate,
      required this.avartar,
      required this.discription,
      required this.backgroundIMG});
  final String uid;
  final String titleEvent;
  final String userName;
  final String location;
  final Timestamp startDate;
  final String avartar;
  final String discription;
  final String backgroundIMG;
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
                      image: NetworkImage(backgroundIMG) ??
                          AssetImage('assets/event.png'),
                      repeat: ImageRepeat.repeatX,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                    gradient: LinearGradient(
                        colors: [Colors.black45, Colors.black45]))),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Details(
                userName: userName,
                uid: uid,
                titleEvent: titleEvent,
                location: location,
                startDate: startDate,
                avartar: avartar ??
                    'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg',
                discription: discription,
              )),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 100),
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        size: 40,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Icon(
                        Icons.directions,
                        size: 40,
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        )
                      ]),
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              child: Center(
                  child: Text(
                'Invite',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
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