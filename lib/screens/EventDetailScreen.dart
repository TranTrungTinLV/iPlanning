import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/services/cloud.dart';
import 'package:iplanning/widgets/details.dart';

class Eventdetailscreen extends StatefulWidget {
  Eventdetailscreen({
    super.key,
    required this.uid,
    required this.titleEvent,
    required this.userName,
    required this.location,
    required this.startDate,
    required this.avartar,
    required this.discription,
    required this.backgroundIMG,
    required this.event_id,
  });
  final String uid;
  final String titleEvent;
  final String userName;
  final String location;
  final Timestamp startDate;
  final String avartar;
  final String discription;
  final String backgroundIMG;
  final String event_id;
  bool isLoadingInvite = true;

  @override
  State<Eventdetailscreen> createState() => _EventdetailscreenState();
}

class _EventdetailscreenState extends State<Eventdetailscreen> {
  bool isInvited = false;
  bool isLoadingWishList = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkInviteStatus();
    _checkWishList();
  }

  void _checkInviteStatus() async {
    setState(() {
      widget.isLoadingInvite = true;
    });
    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('eventPosts')
        .doc(widget.event_id)
        .get();
    if (eventSnapshot.exists && eventSnapshot.data() != null) {
      setState(() {
        isInvited = (eventSnapshot.data() as dynamic)['isPending']
                ?.contains(FirebaseAuth.instance.currentUser!.uid) ??
            false;
        widget.isLoadingInvite = false;
      });
    } else {
      print("Event document does not exist or data is null.");
      widget.isLoadingInvite = false;
    }
  }

  void _checkWishList() async {
    // setState(() {
    //   isLoadingWishList = true;
    // });
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (userSnapshot.exists && userSnapshot.data() != null) {
      setState(() {
        isLoadingWishList = (userSnapshot.data() as dynamic)['wishlist']
                ?.contains(widget.event_id) ??
            false;
      });
    } else {
      print("Event document does not exist or data is null.");
    }
  }

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
                      image: NetworkImage(widget.backgroundIMG) ??
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
                userName: widget.userName,
                uid: widget.uid,
                titleEvent: widget.titleEvent,
                location: widget.location,
                startDate: widget.startDate,
                avartar: (widget.avartar != "" && widget.avartar != null)
                    ? widget.avartar
                    : 'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg',
                discription: widget.discription,
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
            child: GestureDetector(
              onTap: () async {
                await ClouMethods().invitedEvents(
                    FirebaseAuth.instance.currentUser!.uid,
                    widget.event_id,
                    'isPending');
                setState(() {
                  isInvited = !isInvited;
                });
              },
              child: authInstance.currentUser!.uid == widget.uid
                  ? Container()
                  : Container(
                      height: 60,
                      child: Center(
                        child: widget.isLoadingInvite
                            ? Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                  strokeAlign: 1,
                                ),
                              )
                            : Text(
                                isInvited ? 'UnInvite' : 'Invite',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                    ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
              width: MediaQuery.of(context).size.width,
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
                        authInstance.currentUser!.uid == widget.uid
                            ? IconButton(
                                onPressed: () async {},
                                icon: Icon(Icons.more_horiz,
                                    color: Colors.white, size: 24),
                              )
                            : IconButton(
                                onPressed: () async {
                                  await ClouMethods().wishlistUser(
                                      authInstance.currentUser!.uid,
                                      widget.event_id);
                                  setState(() {
                                    isLoadingWishList = !isLoadingWishList;
                                  });
                                },
                                icon: Icon(Icons.bookmark,
                                    color: isLoadingWishList
                                        ? Colors.red
                                        : Colors.white,
                                    size: 24),
                              )
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
