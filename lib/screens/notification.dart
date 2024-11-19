import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/main.dart';
import 'package:iplanning/services/cloud.service.dart';
import 'package:iplanning/services/noti.service.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  NotificationScreen({super.key, required this.getPicture});

  final Function() getPicture;
  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  CollectionReference users = firestoreInstance.collection('users');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notification'),
        actions: const [
          Icon(
            Icons.more_vert,
            size: 22,
          ),
          SizedBox(
            width: 22,
          )
        ],
      ),
      body: StreamBuilder(
          stream: firestoreInstance
              .collection("eventPosts")
              .where('uid', isEqualTo: authInstance.currentUser!.uid)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Failed to load events: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: screenHeight * 0.25,
                      width: screenWidth * 0.5,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            )
                          ],
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'assets/notification.png',
                              ))),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Center(
                      child: Text(
                        'No Notifications',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                    ),
                  ],
                ),
              );
            }

            final eventDocs = snapshot.data!.docs.where((eventDoc) {
              final List<dynamic>? isPending = eventDoc['isPending'];
              return isPending != null && isPending.isNotEmpty;
            }).toList();
            if (eventDocs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: screenHeight * 0.25,
                      width: screenWidth * 0.5,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            )
                          ],
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'assets/notification.png',
                              ))),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Center(
                      child: Text(
                        'No Notifications',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
                itemCount: eventDocs.length,
                itemBuilder: (context, index) {
                  final eventDoc = eventDocs[index];
                  final List<dynamic> isPending = eventDoc['isPending'];
                  final eventId = eventDoc['event_id'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...isPending.map((uid) {
                        return FutureBuilder(
                            future: users.doc(uid).get(),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: const CircularProgressIndicator());
                              } else if (userSnapshot.hasError ||
                                  !userSnapshot.hasData) {
                                return Text(
                                    'Failed to load user: ${userSnapshot.error}');
                              } else if (!userSnapshot.hasData) {
                                return const Text('User not found');
                              }
                              final userDoc = userSnapshot.data!;

                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.03,
                                    vertical: screenHeight * 0.015),
                                child: Card(
                                  color: Colors.white.withOpacity(0.8),
                                  child: Container(
                                    // margin: const EdgeInsets.symmetric(
                                    //     vertical: 12, horizontal: 10),
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.015,
                                        horizontal: screenWidth * 0.03),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CircleAvatar(
                                              radius: screenWidth * 0.06,
                                              backgroundColor: Colors.red,
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.04,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    "${userDoc['name']} muốn tham gia",
                                                    style: TextStyle(
                                                        fontSize:
                                                            screenWidth * 0.04),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.01),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await ClouMethods()
                                                            .invitedEvents(
                                                                uid,
                                                                eventId,
                                                                'isRejected');
                                                        await widget
                                                            .getPicture();
                                                      },
                                                      child: Container(
                                                        width:
                                                            screenWidth * 0.25,
                                                        height:
                                                            screenHeight * 0.06,
                                                        child: Center(
                                                            child:
                                                                Text('Reject')),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.1),
                                                                    blurRadius:
                                                                        10.0,
                                                                    spreadRadius:
                                                                        2.0,
                                                                  )
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.03,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await ClouMethods()
                                                            .invitedEvents(
                                                          uid,
                                                          eventId,
                                                          'isAccepted',
                                                        );
                                                      },
                                                      child: Container(
                                                        width:
                                                            screenWidth * 0.25,
                                                        height:
                                                            screenHeight * 0.06,
                                                        child: Center(
                                                            child: Text(
                                                          'Accept',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Color(
                                                                    0xff5669FF),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.1),
                                                                    blurRadius:
                                                                        10.0,
                                                                    spreadRadius:
                                                                        2.0,
                                                                  )
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              child: Text(
                                                'Just Now',
                                                style: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.03),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }).toList(),
                    ],
                  );
                });
          }),
    );
  }
}
