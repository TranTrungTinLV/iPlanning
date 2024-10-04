import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference eventPosts =
        FirebaseFirestore.instance.collection('eventPosts');

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Wishlist'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator()),
                      ],
                    ));
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Failed to load wishlist: ${snapshot.error}'));
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('No Wishlist Available'));
              }

              // Lấy tài liệu người dùng từ snapshot
              final userDoc = snapshot.data;

              // Kiểm tra sự tồn tại của trường 'wishlist'
              if (userDoc!['wishlist'] == null ||
                  (userDoc['wishlist'] as List).isEmpty) {
                return const Center(child: Text('No Wishlist Available'));
              }

              final List<dynamic> wishlist = userDoc['wishlist'];

              return ListView.builder(
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final String eventId = wishlist[index];
                  return FutureBuilder<DocumentSnapshot>(
                    future: eventPosts.doc(eventId).get(),
                    builder: (context, eventSnapShot) {
                      if (eventSnapShot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (eventSnapShot.hasError ||
                          !eventSnapShot.hasData ||
                          !eventSnapShot.data!.exists) {
                        return const Text('Event not found in Wishlist');
                      }

                      final eventDoc = eventSnapShot.data!;
                      return ListTile(
                        title: Text(eventDoc['event_name'] ?? 'No Event Name'),
                        subtitle:
                            Text(eventDoc['description'] ?? 'No Description'),
                      );
                    },
                  );
                },
              );
            }));
  }
}
