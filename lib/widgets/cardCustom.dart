import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/events_model.dart';

class CardCustom extends StatelessWidget {
  const CardCustom({
    super.key,
    required this.RandomImages,
    required this.event,
    required this.uid,
  });

  final List RandomImages;
  final EventsPostModel event;
  final String uid;
  @override
  Widget build(BuildContext context) {
    var isMe = authInstance.currentUser!.uid == uid;
    print(isMe);
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.4,
      margin: const EdgeInsets.only(right: 10.0),
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: Stack(
          children: [
            Column(
              // mainAxisAlignment:
              //     MainAxisAlignment.start,
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
                          fit: BoxFit.fill,
                          repeat: ImageRepeat.noRepeat,
                          image: NetworkImage(event.eventImage != null
                              ? event.eventImage![0]
                              : 'http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcRvC27D9KlxeEham1w-Wpd_pu3hd4A-OywxRbdnx9JFLpcTD7dfL0bD_WI6Ro8QkzrPLkBMzA9osrMpi4JSP5Y'),
                          filterQuality: FilterQuality.high)),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10, left: 10),
                        child: Text(
                          event.event_name,
                          style: TextStyle(color: Colors.black, fontSize: 20),
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
                            child: const Text(
                              '+20 Going',
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
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(event.location),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
