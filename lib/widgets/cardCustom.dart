import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/services/cloud.dart';

class CardCustom extends StatelessWidget {
  const CardCustom({
    super.key,
    required this.RandomImages,
    required this.event,
    required this.uid,
    required this.count,
  });

  final List RandomImages;

  final EventsPostModel event;
  final String uid;
  final int count;
  @override
  Widget build(BuildContext context) {
    var isMe = authInstance.currentUser!.uid == uid;
    print(isMe);
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.only(right: 10.0),
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          opacity: 0.8,
                          fit: BoxFit.cover,
                          repeat: ImageRepeat.noRepeat,
                          image: NetworkImage(event.eventImage != null
                              ? event.eventImage![0]
                              : 'http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcRvC27D9KlxeEham1w-Wpd_pu3hd4A-OywxRbdnx9JFLpcTD7dfL0bD_WI6Ro8QkzrPLkBMzA9osrMpi4JSP5Y'),
                          filterQuality: FilterQuality.high)),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 0, bottom: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "International Band Mu...",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Row(
                            children: [
                              for (int i = 0; i < RandomImages.length; i++)
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  child: Align(
                                      widthFactor: 0.5,
                                      child: CircleAvatar(
                                        // radius: 50,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 60,
                                          backgroundImage: NetworkImage(
                                            RandomImages[i],
                                          ),
                                        ),
                                      )),
                                ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: count <= 0
                                ? Container()
                                : Text(
                                    '${count.toString()} Going',
                                    style: TextStyle(
                                        color: Color(0xff3F38DD), fontSize: 15),
                                  ),
                          ),
                          const SizedBox()
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20.0,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(event.location),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 10.0,
                            backgroundImage: NetworkImage(event.profilePic),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text("By ${event.username}"),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
