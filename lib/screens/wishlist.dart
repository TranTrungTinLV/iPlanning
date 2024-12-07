import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/screens/EventDetailScreen.dart';
import 'package:iplanning/services/cloud.service.dart';

class WishListScreen extends StatefulWidget {
  WishListScreen({
    super.key,
    required this.event_id,
    required this.RandomImages,
  });
  final String? event_id;
  final List RandomImages;
  bool isLoadingInvite = true;
  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // void _checkInviteStatus() async {
  //   setState(() {
  //     widget.isLoadingInvite = true;
  //   });

  //   DocumentSnapshot eventSnapshot = await firestoreInstance
  //       .collection('eventPosts')
  //       .doc(widget.event_id)
  //       .get();

  //   if (eventSnapshot.exists && eventSnapshot.data() != null) {
  //     final eventData = eventSnapshot.data() as Map<String, dynamic>;
  //     String currentUserId = authInstance.currentUser!.uid;
  //     print("isAccepted: ${eventData['isAccepted']}");
  //     print("isPending: ${eventData['isPending']}");
  //     print(currentUserId);
  //     setState(() {
  //       if (eventData['isAccepted'].contains(currentUserId) ?? false) {
  //         isInvited = true;
  //       } else if (eventData['isPending'].contains(currentUserId) ?? false) {
  //         isInvited = false;
  //       } else {
  //         isInvited = null;
  //       }
  //       print("trạng thái $isInvited");
  //       widget.isLoadingInvite = false;
  //     });
  //   } else {
  //     print("Event document does not exist or data is null.");
  //     widget.isLoadingInvite = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    CollectionReference eventPosts = firestoreInstance.collection('eventPosts');

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Wishlist'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: firestoreInstance
                .collection("users")
                .doc(authInstance.currentUser!.uid)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
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

              final userDoc = snapshot.data;

              if (userDoc!['wishList'] == null ||
                  (userDoc['wishList'] as List).isEmpty) {
                return const Center(child: Text('No Wishlist Available'));
              }

              final List<dynamic> wishlist = userDoc['wishList'];

              return ListView.builder(
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final String eventId = wishlist[index];
                  return FutureBuilder<DocumentSnapshot>(
                    future: eventPosts.doc(eventId).get(),
                    builder: (context, eventSnapShot) {
                      if (widget.event_id == null || widget.event_id!.isEmpty) {
                        return const Center(
                            child: Text('No event ID available'));
                      }
                      if (snapshot.hasError) {
                        return CircularProgressIndicator();
                      } else if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Center(child: Text('No Data Available'));
                      } else if (eventSnapShot.hasError ||
                          !eventSnapShot.hasData ||
                          !eventSnapShot.data!.exists) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final eventDoc = eventSnapShot.data!;
                      final eventData = eventDoc.data() as Map<String, dynamic>;

                      final currentUserId =
                          FirebaseAuth.instance.currentUser!.uid;
                      bool? isEventInvited;
                      if (eventData['isAccepted']?.contains(currentUserId) ??
                          false) {
                        isEventInvited = true;
                      } else if (eventData['isPending']
                              ?.contains(currentUserId) ??
                          false) {
                        isEventInvited = false;
                      } else {
                        isEventInvited = null;
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                            return Eventdetailscreen(
                                uid: eventDoc['uid'],
                                titleEvent: eventDoc['event_name'],
                                userName: eventDoc['username'],
                                location: eventDoc['location']!,
                                startDate: eventDoc['eventDateStart'],
                                endDate: eventDoc['eventDateEnd'],
                                avartar: eventDoc['profilePic'] ??
                                    'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg',
                                discription: eventDoc['description'] ??
                                    'không có nội dung ở đây',
                                backgroundIMG: eventDoc['eventImage']![0],
                                RandomImages: widget.RandomImages,
                                event_id: eventDoc['event_id']);
                          }));
                        },
                        child:
                            buildEventCard(eventDoc, isEventInvited, eventId),
                      );
                    },
                  );
                },
              );
            }));
  }

  Widget buildEventCard(
      DocumentSnapshot eventDoc, bool? isEventInvited, String eventId) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).size.height * 0.45,
      child: Card(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(eventDoc['eventImage'][0])),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () async {
                          await ClouMethods().removeWishList(
                              authInstance.currentUser!.uid, eventId);
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.highlight_remove_rounded,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                eventDoc['event_name'] ?? 'No event_name',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${(eventDoc['eventDateStart'] as Timestamp).toDate().day.toString()}-${(eventDoc['eventDateEnd'] as Timestamp).toDate().day.toString()} ${(eventDoc['eventDateStart'] as Timestamp).toDate().month.toString()}, ${(eventDoc['eventDateStart'] as Timestamp).toDate().year.toString()}",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  // ! location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        (eventDoc["location"] != null &&
                                eventDoc["location"] != "")
                            ? eventDoc["location"]
                            : "Hiện chưa có",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      "Author: ${eventDoc['username'] ?? ''}",
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // await ClouMethods().invitedEvents(
                      //     FirebaseAuth
                      //         .instance.currentUser!.uid,
                      //     eventDoc['event_id'],
                      //     'isPending');
                      // setState(() {
                      //   isInvited = !isInvited!;
                      // });
                    },
                    child: Container(
                      height: 40,
                      child: Center(
                        child: Text(
                          isEventInvited == true
                              ? 'Đang tham gia'
                              : isEventInvited == false
                                  ? 'Huỷ tham gia'
                                  : 'Tham gia',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          color: isEventInvited == true
                              ? Colors.green
                              : Color(0xff3D56F0),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
