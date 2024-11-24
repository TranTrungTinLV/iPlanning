import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:intl/intl.dart';

class Details extends StatefulWidget {
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
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isExpended = true;
  @override
  Widget build(BuildContext context) {
    final isMe = authInstance.currentUser!.uid == widget.uid;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final _formatterAmount =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06, vertical: screenHeight * 0.03),
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
                      width: screenWidth * 0.5,
                      child: Text(
                        widget.titleEvent ?? '',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 18, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (widget.location.isNotEmpty)
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.location_on),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04),
                                        widget.location,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                Icon(Icons.date_range),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  child: Text(
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03),
                                      "${widget.startDate.toDate().day}-${widget.startDate.toDate().month}-${widget.startDate.toDate().year}" ??
                                          'Start Date'),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.timer_outlined),
                              SizedBox(width: 10.0),
                              Container(
                                child: Text(
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03),
                                    "${DateFormat('HH:mm').format(widget.startDate.toDate()) ?? 'Start Time'}" ??
                                        'Start Time'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                isMe
                    ? Container()
                    : GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${widget.ammount != null && widget.ammount != 0.0 ? _formatterAmount.format(widget.ammount).toString().replaceAll('.', ',') : "Free"}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03),
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
                    widget.onTap();
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.06,
                        backgroundImage: NetworkImage(widget.avartar.isNotEmpty
                            ? widget.avartar
                            : 'https://thumbs.dreamstime.com/b/profile-anonymous-face-icon-gray-silhouette-person-male-default-avatar-photo-placeholder-white-background-vector-illustration-106473768.jpg'),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              widget.userName ?? 'User name',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.035),
                            ),
                          ),
                          Container(
                            child: Text(
                              isMe ? 'Me' : 'hosting',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03),
                            ),
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
              margin: EdgeInsets.only(top: 20, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mô tả',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maxLines: widget.discription.length > 50
                            ? isExpended
                                ? 2
                                : null
                            : 2,
                        overflow: widget.discription.length > 50
                            ? isExpended
                                ? TextOverflow.ellipsis
                                : TextOverflow.visible
                            : TextOverflow.visible,
                        textAlign: TextAlign.justify,
                        widget.discription ?? '',
                        style: TextStyle(
                            height: 1.5,
                            fontSize: MediaQuery.of(context).size.width * 0.03),
                      ),
                      if (widget.discription.length > 50)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpended = !isExpended;
                            });
                          },
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Xem thêm",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Icon(isExpended
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_drop_up)
                            ],
                          )),
                        )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      // ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      width: MediaQuery.of(context).size.width,
    );
  }
}
