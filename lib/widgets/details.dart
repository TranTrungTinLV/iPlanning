import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';

class Details extends StatelessWidget {
  Details(
      {super.key,
      required this.uid,
      required this.titleEvent,
      required this.userName,
      required this.location,
      required this.startDate,
      required this.avartar,
      required this.discription,
      required this.ammount,
      required this.onTap});
  final String uid;
  final double ammount;
  final String titleEvent;
  final String userName;
  final String location;
  final String avartar;
  final Timestamp startDate;
  final String discription;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    var isMe = authInstance.currentUser!.uid == uid;
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 80),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        titleEvent ?? 'Event Name',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Container(
                      // color: Colors.red,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on),
                          Container(
                            child: Text((location != "" && location != null)
                                ? location
                                : 'Đang cập nhật'),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Row(
                            children: [
                              Icon(Icons.date_range),
                              Container(
                                child: Text(
                                    "${startDate.toDate().day}-${startDate.toDate().month}-${startDate.toDate().year}" ??
                                        'Start Date'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                isMe
                    ? Container()
                    : GestureDetector(
                        child: Container(
                            width: 80,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "${ammount != null && ammount != 0.0 ? ammount.toString() : "Free"}",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 10),
                            )),
                      )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: Divider(
                height: 20,
                thickness: 0.2,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    print("Hello");
                    onTap();
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(avartar),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              userName ?? 'User name',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                          ),
                          Container(
                            child: Text(isMe ? 'Me' : 'hosting'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                isMe
                    ? Icon(Icons.more_horiz)
                    : Icon(Icons.messenger_outline_outlined)
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Desctiption',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    discription ??
                        'Ultricies arcu venenatis in lorem faucibus lobortis at. East odio varius nisl congue aliquam nunc est sit pull convallis magna. Est scelerisque dignissim non nibh....',
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      width: MediaQuery.of(context).size.width,
    );
  }
}
