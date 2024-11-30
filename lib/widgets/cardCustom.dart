import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/services/cloud.service.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.7,
      margin: EdgeInsets.only(right: 10.0),
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
                  margin: EdgeInsets.all(screenWidth * 0.03),
                  height: screenHeight * 0.2,
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
                          event.event_name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.048,
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.06,
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
                                    '${count.toString()} tham gia',
                                    style: TextStyle(
                                      color: Color(0xff3F38DD),
                                      fontSize: screenWidth * 0.032,
                                    ),
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
                      event.location!.isNotEmpty
                          ? Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: screenWidth * 0.05,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.01,
                                ),
                                Container(
                                  width: screenWidth * 0.5,
                                  child: Text(
                                    event.location ?? '',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: screenWidth * 0.03,
                            backgroundImage: NetworkImage(event
                                    .profilePic.isNotEmpty
                                ? event.profilePic
                                : 'https://thumbs.dreamstime.com/b/profile-anonymous-face-icon-gray-silhouette-person-male-default-avatar-photo-placeholder-white-background-vector-illustration-106473768.jpg'),
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Text(
                            "By ${event.username}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
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
