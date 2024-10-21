// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/screens/profileScreen.dart';
import 'package:iplanning/services/auth.dart';
import 'package:iplanning/services/cloud.dart';
import 'package:iplanning/widgets/details.dart';

class Eventdetailscreen extends StatefulWidget {
  Eventdetailscreen({
    Key? key,
    required this.uid,
    required this.titleEvent,
    required this.userName,
    required this.location,
    required this.startDate,
    required this.avartar,
    required this.discription,
    required this.backgroundIMG,
    required this.event_id,
    required this.ammount,
    // required this.userProfile,
  }) : super(key: key);
  final String uid;
  final String titleEvent;
  final String userName;
  final String location;
  final Timestamp startDate;
  final String avartar;
  final String discription;
  final String backgroundIMG;
  final String event_id;
  final double ammount;
  // UserModel? userProfile;

  bool isLoadingInvite = true;

  @override
  State<Eventdetailscreen> createState() => _EventdetailscreenState();
}

class _EventdetailscreenState extends State<Eventdetailscreen> {
  bool? isInvited = false;
  bool isLoadingWishList = false;
  final _formatterAmount = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  UserModel? userProfile;
  final _authService = AuthenticationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkInviteStatus();
    _checkWishList();
    _loadUserData();
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
      var eventData = eventSnapshot.data() as Map<String, dynamic>;
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      setState(() {
        // Kiểm tra nếu người dùng đã được chấp nhận
        if (eventData['isAccepted']?.contains(currentUserId) ?? false) {
          isInvited = true; // Đã được chấp nhận
        } else if (eventData['isPending']?.contains(currentUserId) ?? false) {
          isInvited = false; // Đã mời nhưng chưa được chấp nhận
        } else {
          isInvited = null; // Chưa được mời
        }
        widget.isLoadingInvite = false;
      });
    } else {
      print("Event document does not exist or data is null.");
      widget.isLoadingInvite = false;
    }
  }

  Future<void> _loadUserData() async {
    setState(() {});
    UserModel? userData = await _authService.getUserProfile(widget.uid);
    print(userData);
    if (mounted) {
      setState(() {
        userProfile = userData;
      });
    }
  }

  void _checkWishList() async {
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

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Bạn có chắc muốn huỷ tham gia sự kiện?"),
                content: Text("Bạn sẽ không còn được xem sự kiện này nữa."),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pop(false); // Người dùng không muốn hủy tham gia
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffE9EFF2),
                        ),
                        padding: EdgeInsetsDirectional.all(10),
                        child: Text("Quay lại")),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(true); // Người dùng đồng ý hủy
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Huỷ tham gia",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              );
            }) ??
        false;
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
          // !Detail
          Align(
            alignment: Alignment.bottomCenter,
            // child: GestureDetector(
            //   child:
            child: Details(
              ammount:
                  _formatterAmount.format(widget.ammount).replaceAll('.', ','),
              userName: widget.userName,
              uid: widget.uid,
              titleEvent: widget.titleEvent,
              location: widget.location,
              startDate: widget.startDate,
              avartar: (widget.avartar != "" && widget.avartar != null)
                  ? widget.avartar
                  : 'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg',
              discription: widget.discription,
              onTap: () {
                if (userProfile != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ProfileScreen(
                        enteredemail: userProfile!.email,
                        username: userProfile!.name,
                        avatarEdit: (widget.avartar != "" &&
                                widget.avartar != null)
                            ? widget.avartar
                            : 'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg',
                        userData: userProfile!,
                      ),
                    ),
                  );
                } else {
                  // Handle case where profile data is not yet loaded
                  Fluttertoast.showToast(
                    msg:
                        "User profile is still loading. Please try again later.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              },
            ),
            // ),
          ),
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
                if (isInvited == null) {
                  // Người dùng chưa được mời, thực hiện mời
                  await ClouMethods().invitedEvents(
                    FirebaseAuth.instance.currentUser!.uid,
                    widget.event_id,
                    'isPending',
                  );
                  setState(() {
                    isInvited =
                        false; // Sau khi mời, chuyển thành trạng thái 'Uninvite'
                  });
                } else if (isInvited == false) {
                  // Người dùng đã được mời nhưng chưa được chấp nhận, thực hiện Uninvite
                  await ClouMethods().invitedEvents(
                    FirebaseAuth.instance.currentUser!.uid,
                    widget.event_id,
                    'isPending',
                  );
                  setState(() {
                    isInvited =
                        null; // Sau khi Uninvite, chuyển về trạng thái 'Invite'
                  });
                } else if (isInvited == true) {
                  // Nếu người dùng đã được chấp nhận và muốn huỷ tham gia
                  bool shouldExit = await showExitConfirmationDialog(context);
                  if (shouldExit) {
                    // Thực hiện huỷ tham gia trong Firebase
                    await ClouMethods().invitedEvents(
                      FirebaseAuth.instance.currentUser!.uid,
                      widget.event_id,
                      'isAccepted', // Xóa người dùng khỏi danh sách được chấp nhận
                    );
                    setState(() {
                      isInvited =
                          null; // Sau khi huỷ, quay về trạng thái 'Invite'
                    });
                  }
                }
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
                            : isInvited == true
                                ? Text(
                                    'Đang tham gia',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  )
                                : isInvited == false
                                    ? Text(
                                        'Uninvite',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      )
                                    : Text(
                                        'Invite',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                      decoration: BoxDecoration(
                          color:
                              isInvited == true ? Colors.green : Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                    ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.15)),
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
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
