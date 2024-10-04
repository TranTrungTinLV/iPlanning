import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                    color: Colors.white.withOpacity(0.2),
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
                    // List<String> pendingUids = List<String>.from(isPending);
                    return ListTile(
                      // title: Text(eventDoc['name'] ?? 'No Title'),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...isPending.map((uid) {
                            return FutureBuilder(
                                future: users.doc(uid).get(),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child:
                                            const CircularProgressIndicator());
                                  } else if (userSnapshot.hasError ||
                                      !userSnapshot.hasData) {
                                    return Text(
                                        'Failed to load user: ${userSnapshot.error}');
                                  } else if (!userSnapshot.hasData) {
                                    return const Text('User not found');
                                  }
                                  final userDoc = userSnapshot.data!;
                                  // final String? userName = userDoc['name'];

                                  return ListTile(
                                    title: Text(userDoc['name']),
                                  );
                                });
                          }).toList(),
                        ],
                      ),
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
