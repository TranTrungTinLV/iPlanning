import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:intl/intl.dart';
import 'package:iplanning/models/todo_models.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/services/auth.service.dart';
import 'package:iplanning/utils/todoStatus.dart';

class Details extends StatefulWidget {
  Details(
      {super.key,
      required this.RandomImages,
      required this.uid,
      required this.titleEvent,
      required this.userName,
      required this.location,
      required this.startDate,
      required this.endDate,
      required this.avartar,
      required this.count,
      required this.discription,
      required this.ammount,
      required this.todoList,
      this.isLoading = false,
      this.isShow = false,
      required this.onTap});
  final String uid;
  final double ammount;
  final String titleEvent;
  final String userName;
  final String location;
  final String avartar;
  final Timestamp startDate;
  final Timestamp endDate;

  final String discription;
  final void Function() onTap;
  final bool isShow;
  final int count;
  final List RandomImages;
  final bool isLoading;
  final List<Map<String, dynamic>> todoList;
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isExpended = true;
  final AuthenticationService _authService = AuthenticationService();
  String getEventStatus({bool showTime = false}) {
    final now = DateTime.now();
    final start = widget.startDate.toDate();
    final end = widget.endDate.toDate();

    if (now.isAfter(end)) {
      return "Kết thúc";
    } else if (now.isBefore(start)) {
      final remainingMinutes = start.difference(now).inMinutes;
      if (remainingMinutes > 0 && remainingMinutes <= 10) {
        return "Còn lại $remainingMinutes phút nữa diễn ra";
      }
      return "${DateFormat('HH:mm').format(start)}";
    } else if (now.isAfter(start) && now.isBefore(end)) {
      return "Đang diễn ra ";
    }
    return "Không xác định";
  }

  @override
  Widget build(BuildContext context) {
    final isMe = authInstance.currentUser!.uid == widget.uid;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final _formatterAmount =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    Future<String> fetchUserName(String uid) async {
      try {
        UserModel? user = await _authService.getUserProfile(uid);
        return user?.name ?? 'Không có tên';
      } catch (e) {
        print('Lỗi khi lấy tên người dùng: $e');
        return 'Không tìm thấy';
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      padding: EdgeInsets.only(
        right: screenHeight * 0.06,
        left: screenWidth * 0.06,
        top: screenHeight * 0.03,
        // bottom: screenHeight * 0.09,
      ),

      child: SingleChildScrollView(
        child: widget.isLoading
            ? Container(
                height: screenHeight * 0.5,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
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
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.location_on),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Text(
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
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
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.02,
                                      ),
                                      Row(
                                        children: [
                                          for (int i = 0;
                                              i < widget.RandomImages.length;
                                              i++)
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Align(
                                                  widthFactor: 0.3,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: CircleAvatar(
                                                      radius:
                                                          screenWidth * 0.05,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        widget.RandomImages[i],
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          widget.count <= 0
                                              ? Container()
                                              : Text(
                                                  "${widget.count} tham gia",
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03),
                                                ),
                                        ],
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
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03),
                                          getEventStatus(showTime: false)),
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
                                            MediaQuery.of(context).size.width *
                                                0.03),
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
                              backgroundImage: NetworkImage(widget
                                      .avartar.isNotEmpty
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
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    isMe ? 'Me' : 'hosting',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03),
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
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.description,
                              size: screenWidth * 0.03,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Mô tả',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.035),
                            ),
                          ],
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
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Icon(isExpended
                                        ? Icons.arrow_drop_down
                                        : Icons.arrow_drop_up)
                                  ],
                                )),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                  (isMe || widget.isShow)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.work,
                                  size: screenWidth * 0.03,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  child: Text(
                                    "Danh sách công việc cần làm",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035),
                                  ),
                                ),
                              ],
                            ),
                            widget.todoList.isEmpty
                                ? const Text("Không có công việc nào.",
                                    style: TextStyle(color: Colors.grey))
                                : Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    width: screenWidth,
                                    margin: EdgeInsets.only(
                                        top: screenHeight * 0.01),
                                    height: screenHeight * 0.15,
                                    child: ListView.builder(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0.0),
                                        itemCount: widget.todoList.length,
                                        itemBuilder: (context, index) {
                                          final taskDoc =
                                              widget.todoList[index];
                                          final todo = TodoModel.fromJson(
                                              taskDoc as Map<String, dynamic>);
                                          return FutureBuilder<String>(
                                              future: fetchUserName(
                                                  todo.assignedUserId),
                                              builder: (context, snapshot) {
                                                String userName = snapshot
                                                            .connectionState ==
                                                        ConnectionState.waiting
                                                    ? 'Đang tải...'
                                                    : snapshot.data ??
                                                        'Không tìm thấy';
                                                return ListTile(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 0.0),
                                                  minVerticalPadding: 4.0,
                                                  minTileHeight: 0.0,
                                                  leading: Text(
                                                    '\u2022',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  minLeadingWidth: 3.0,
                                                  title: Text(
                                                    '${todo.title}-${userName}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.035,
                                                        decoration: todo
                                                                    .completed ==
                                                                TodoStatus
                                                                    .completed
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : null,
                                                        decorationColor: todo
                                                                    .completed ==
                                                                TodoStatus
                                                                    .completed
                                                            ? Colors
                                                                .green.shade400
                                                            : null,
                                                        color: todo.completed ==
                                                                TodoStatus
                                                                    .completed
                                                            ? Colors
                                                                .green.shade400
                                                            : todo.completed ==
                                                                    TodoStatus
                                                                        .notStarted
                                                                ? Colors.yellow
                                                                    .shade600
                                                                : null),
                                                  ),
                                                );
                                              });
                                        }),
                                  ),
                          ],
                        )
                      : Container()
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
