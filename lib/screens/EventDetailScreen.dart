import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/providers/event_provider.dart';
import 'package:iplanning/screens/guestList.dart';
import 'package:iplanning/screens/mainScreen/createEventScreens.dart';
import 'package:iplanning/screens/notification.dart';
import 'package:iplanning/screens/mainScreen/profileScreen.dart';
import 'package:iplanning/services/auth.service.dart';
import 'package:iplanning/services/cloud.service.dart';
import 'package:iplanning/services/noti.service.dart';
import 'package:iplanning/widgets/details.dart';

class Eventdetailscreen extends ConsumerStatefulWidget {
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
    required this.RandomImages,
    required this.event_id,
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
  final List RandomImages;
  bool isLoadingInvite = true;

  @override
  ConsumerState<Eventdetailscreen> createState() => _EventdetailscreenState();
}

class _EventdetailscreenState extends ConsumerState<Eventdetailscreen> {
  bool? isInvited = false;
  bool isLoadingWishList = false;
  final _formatterAmount = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  UserModel? userProfile;
  final _authService = AuthenticationService();
  double? ammount;
  List<Map<String, dynamic>> _todoList = [];
  bool _isLoadingTodo = true;
  String? _selectedCategoryName;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initStainitSte
    super.initState();
    _checkInviteStatus();
    _checkWishList();
    _loadUserData();
    _loadTodoList();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.event_id.isNotEmpty) {
        await ref
            .read(eventStateProvider.notifier)
            .fetchEventById(widget.event_id);
      }
    });

    getBudgetFromEventPOST(widget.event_id);
  }

  Future<double?> getBudgetFromEventPOST(String eventId) async {
    QuerySnapshot snapshot = await firestoreInstance
        .collection('budgets')
        .where('event_id', isEqualTo: eventId)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final budgetDoc = snapshot.docs.first;
      double? paidAmount =
          (budgetDoc.data() as Map<String, dynamic>)['paidAmount'];
      setState(() {
        ammount = paidAmount;
      });
      print("eventId ${eventId}");
      return paidAmount;
    } else {
      print('No budget found for event_id: $eventId');
      return null;
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    QuerySnapshot snapshot =
        await firestoreInstance.collection('categoriesEvent').get();
    print("Fetched Categories:");
    snapshot.docs.forEach((doc) {
      print(doc.data());
    });
    return snapshot.docs.map((doc) {
      return CategoryModel(
        category_id: doc['category_id'],
        name: doc['name'],
        event_ids: List<String>.from(doc['event_ids']),
      );
    }).toList();
  }

  // !Todo List fetch
  Future<List<Map<String, dynamic>>> fetchTodoList(String eventId) async {
    List<Map<String, dynamic>> todos = [];
    try {
      QuerySnapshot querySnapshot = await firestoreInstance
          .collection('todos')
          .where('event_ids', isEqualTo: eventId)
          .get();
      todos = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching todos: $e");
    }

    return todos;
  }

  Future<void> _loadTodoList() async {
    List<Map<String, dynamic>> todos = await fetchTodoList(widget.event_id);
    if (mounted) {
      setState(() {
        _todoList = todos;
        _isLoadingTodo = false;
      });
    }
  }

  void _checkInviteStatus() async {
    setState(() {
      widget.isLoadingInvite = true;
    });

    DocumentSnapshot eventSnapshot = await firestoreInstance
        .collection('eventPosts')
        .doc(widget.event_id)
        .get();

    if (eventSnapshot.exists && eventSnapshot.data() != null) {
      var eventData = eventSnapshot.data() as Map<String, dynamic>;
      String currentUserId = authInstance.currentUser!.uid;

      setState(() {
        if (eventData['isAccepted']?.contains(currentUserId) ?? false) {
          isInvited = true;
        } else if (eventData['isPending']?.contains(currentUserId) ?? false) {
          isInvited = false;
        } else {
          isInvited = null;
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
    DocumentSnapshot userSnapshot = await firestoreInstance
        .collection('users')
        .doc(authInstance.currentUser!.uid)
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
                      Navigator.of(context).pop(false);
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
                      Navigator.of(context).pop(true);
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
    final eventState = ref.watch(eventStateProvider);
    final event = eventState.eventDetails;

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.backgroundIMG.isNotEmpty
                      ? widget.backgroundIMG
                      : (event?.eventImage?.isNotEmpty == true
                          ? event!.eventImage![0]
                          : 'https://example.com/default-image.png')),
                  repeat: ImageRepeat.repeatX,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
                gradient:
                    LinearGradient(colors: [Colors.black45, Colors.black45]),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Details(
              count: eventState.eventDetails!.invitersCount,
              isShow: eventState.eventDetails!.isPost,
              RandomImages: widget.RandomImages,
              todoList: _todoList,
              isLoading: eventState.isLoadingInvite,
              ammount: eventState.ammount ?? 0,
              userName: widget.userName,
              uid: widget.uid,
              titleEvent: event?.event_name ?? widget.titleEvent,
              location: event?.location ?? widget.location,
              startDate: event?.eventDateStart != null
                  ? event!.eventDateStart
                  : widget.startDate,
              avartar: widget.avartar,
              discription: event?.description ?? widget.discription,
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (isInvited == null) {
                  await ClouMethods().invitedEvents(
                    authInstance.currentUser!.uid,
                    widget.event_id,
                    'isPending',
                  );
                  final currentUserId =
                      authInstance.currentUser!.uid == widget.uid;
                  setState(() {
                    isInvited = false;
                  });
                } else if (isInvited == false) {
                  await ClouMethods().invitedEvents(
                    authInstance.currentUser!.uid,
                    widget.event_id,
                    'isPending',
                  );
                  setState(() {
                    isInvited = null;
                  });
                } else if (isInvited == true) {
                  bool shouldExit = await showExitConfirmationDialog(context);
                  if (shouldExit) {
                    await ClouMethods().invitedEvents(
                      authInstance.currentUser!.uid,
                      widget.event_id,
                      'isAccepted',
                    );
                    setState(() {
                      isInvited = null;
                    });
                  }
                }
              },
              child: authInstance.currentUser!.uid == widget.uid
                  ? Container()
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.08,
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
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )
                                : isInvited == false
                                    ? Text(
                                        'Uninvite',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.045,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      )
                                    : Text(
                                        'Invite',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.045,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      decoration: BoxDecoration(
                          color: isInvited == true
                              ? Colors.green
                              : Color(0xff3D56F0),
                          borderRadius: BorderRadius.circular(20)),
                    ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.15)),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 30, sigmaY: 30),
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
                          Row(
                            children: [
                              IconButton(
                                icon: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 30, sigmaY: 30),
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
                                        ? PopupMenuButton<String>(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                            ),
                                            itemBuilder: (BuildContext ctx) => [
                                                  const PopupMenuItem<String>(
                                                      value: 'GuestList',
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.person),
                                                          Text('Guest List'),
                                                        ],
                                                      )),
                                                  const PopupMenuItem<String>(
                                                      value: 'EditEvent',
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.edit),
                                                          Text('Chỉnh sửa'),
                                                        ],
                                                      )),
                                                ],
                                            onSelected: (String result) async {
                                              if (result == 'GuestList') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          GuestList(
                                                            eventId:
                                                                widget.event_id,
                                                          )),
                                                );
                                              } else {
                                                List<CategoryModel> categories =
                                                    await fetchCategories();
                                                final isUpdated =
                                                    Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          CreateEventScreens(
                                                            list:
                                                                categories, // Truyền danh sách category nếu cần
                                                            uid: widget.uid,
                                                            username:
                                                                widget.userName,
                                                            avatar:
                                                                widget.avartar,
                                                            event_id:
                                                                widget.event_id,
                                                            onEventUpdated: () {
                                                              ref
                                                                  .read(eventStateProvider
                                                                      .notifier)
                                                                  .refreshEvent(
                                                                      widget
                                                                          .event_id);
                                                            },
                                                          )),
                                                );
                                                if (isUpdated == true) {
                                                  ref
                                                      .read(eventStateProvider
                                                          .notifier)
                                                      .refreshEvent(
                                                          widget.event_id);
                                                }
                                              }
                                            })
                                        : IconButton(
                                            onPressed: () async {
                                              await ClouMethods().wishlistUser(
                                                  authInstance.currentUser!.uid,
                                                  widget.event_id);
                                              setState(() {
                                                isLoadingWishList =
                                                    !isLoadingWishList;
                                              });
                                            },
                                            icon: Icon(Icons.bookmark,
                                                color: isLoadingWishList
                                                    ? Colors.red
                                                    : Colors.white,
                                                size: 24),
                                          ),
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
