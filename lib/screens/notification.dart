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
    final authUid = FirebaseAuth.instance.currentUser!.uid;

    final hostingStream = FirebaseFirestore.instance
        .collection("eventPosts")
        .where('uid', isEqualTo: authUid)
        .snapshots();

    final invitedStream = FirebaseFirestore.instance
        .collection("eventPosts")
        .where('isRequestInvite', arrayContains: authUid)
        .snapshots();
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
        stream: hostingStream,
        builder: (context, hostingSnapshot) {
          if (hostingSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (hostingSnapshot.hasError) {
            return Center(
              child: Text(
                  'Failed to load notifications: ${hostingSnapshot.error}'),
            );
          }

          final hostingDocs = hostingSnapshot.data?.docs ?? [];

          return StreamBuilder(
            stream: invitedStream,
            builder: (context, invitedSnapshot) {
              if (invitedSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (invitedSnapshot.hasError) {
                return Center(
                  child: Text(
                      'Failed to load invitations: ${invitedSnapshot.error}'),
                );
              }

              final invitedDocs = invitedSnapshot.data?.docs ?? [];
              final pendingHostingDocs = hostingDocs.where((doc) {
                final isPending = doc['isPending'] as List<dynamic>? ?? [];
                return isPending.isNotEmpty;
              }).toList();
              // Combine hosting and invited notifications
              final combinedNotifications = [
                ...pendingHostingDocs,
                ...invitedDocs
              ];

              if (combinedNotifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off,
                          size: 100, color: Colors.grey),
                      Text(
                        'No Notifications',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: combinedNotifications.length,
                itemBuilder: (context, index) {
                  final doc = combinedNotifications[index];

                  final isHosting = doc['uid'] == authUid;
                  print("Hosting docs: ${hostingDocs.length}");
                  print("Invited docs: ${invitedDocs.length}");

                  if (isHosting) {
                    final isPending = doc['isPending'] as List<dynamic>? ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: isPending.map((uid) {
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: const CircularProgressIndicator());
                            }
                            if (!userSnapshot.hasData) {
                              return const SizedBox.shrink();
                            }

                            final userDoc = userSnapshot.data!;
                            print("User data for $uid: ${userDoc.data()}");
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenHeight * 0.015),
                              child: Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.015,
                                      horizontal: screenWidth * 0.03),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            child: Icon(Icons.person),
                                          ),
                                          SizedBox(
                                            width: 14,
                                          ),
                                          Text(
                                              "${userDoc['name']} muốn tham gia: ${doc['event_name']}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              FirebaseFirestore.instance
                                                  .collection("eventPosts")
                                                  .doc(doc.id)
                                                  .update({
                                                'isPending':
                                                    FieldValue.arrayRemove(
                                                        [uid])
                                              });
                                            },
                                            child: Container(
                                              width: screenWidth * 0.25,
                                              height: screenHeight * 0.06,
                                              child:
                                                  Center(child: Text('Reject')),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 2.0,
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.03,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              FirebaseFirestore.instance
                                                  .collection("eventPosts")
                                                  .doc(doc.id)
                                                  .update({
                                                'isPending':
                                                    FieldValue.arrayRemove(
                                                        [uid]),
                                                'isAccepted':
                                                    FieldValue.arrayUnion([uid])
                                              });
                                            },
                                            child: Container(
                                                width: screenWidth * 0.25,
                                                height: screenHeight * 0.06,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff5669FF),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        blurRadius: 10.0,
                                                        spreadRadius: 2.0,
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                    child: Text(
                                                  "Accept",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.015),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015,
                              horizontal: screenWidth * 0.03),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(Icons.event),
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Text(
                                      "${doc['username']} mời bạn tham gia ${doc['event_name']}"),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection("eventPosts")
                                          .doc(doc.id)
                                          .update({
                                        'isRequestInvite':
                                            FieldValue.arrayRemove([authUid])
                                      });
                                    },
                                    child: Container(
                                        width: screenWidth * 0.25,
                                        height: screenHeight * 0.06,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 10.0,
                                                spreadRadius: 2.0,
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(child: Text("Từ Chối"))),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.03,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection("eventPosts")
                                          .doc(doc.id)
                                          .update({
                                        'isRequestInvite':
                                            FieldValue.arrayRemove([authUid]),
                                        'isAccepted':
                                            FieldValue.arrayUnion([authUid])
                                      });
                                    },
                                    child: Container(
                                        width: screenWidth * 0.25,
                                        height: screenHeight * 0.06,
                                        decoration: BoxDecoration(
                                            color: Color(0xff5669FF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 10.0,
                                                spreadRadius: 2.0,
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            "Chấp nhận",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
