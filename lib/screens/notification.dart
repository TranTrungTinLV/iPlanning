import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/services/cloud.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key, required this.event_id});
  final String event_id;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
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
          stream:
              FirebaseFirestore.instance.collection("eventPosts").snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Failed to load events: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Events Available'));
            }

            // Lấy danh sách event từ snapshot
            final eventDocs = snapshot.data!.docs;

            return ListView.builder(
                itemCount: eventDocs.length,
                itemBuilder: (context, index) {
                  final eventDoc = eventDocs[index];
                  final List<dynamic> isPending = eventDoc['isPending'];
                  if (isPending == null || isPending.isEmpty) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 250,
                            width: 250,
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
                            height: 40,
                          ),
                          Center(
                            child: Text(
                              'No Notifications',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (isPending != null && isPending is List) {
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
                                      horizontal: 10, vertical: 20),
                                  child: Card(
                                    color: Colors.white.withOpacity(0.8),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 10),
                                      padding: EdgeInsetsDirectional.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "${userDoc['name']} invite to",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await ClouMethods()
                                                              .invitedEvents(
                                                                  userDoc[
                                                                      'uid'],
                                                                  widget
                                                                      .event_id,
                                                                  'isRejected');
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          height: 40,
                                                          child: Center(
                                                              child: Text(
                                                                  'Reject')),
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
                                                        width: 13,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await ClouMethods()
                                                              .invitedEvents(
                                                                  userDoc[
                                                                      'uid'],
                                                                  widget
                                                                      .event_id,
                                                                  'isAccepted');
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          height: 40,
                                                          child: Center(
                                                              child: Text(
                                                            'Accept',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
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
                                                  style:
                                                      TextStyle(fontSize: 13),
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
                  } else {
                    Container(
                      child: Text('không có'),
                    );
                  }
                });
          }),
    );
  }
}
