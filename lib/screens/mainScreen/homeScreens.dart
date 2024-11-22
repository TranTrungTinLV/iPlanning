import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/screens/AllEventScreen.dart';
import 'package:iplanning/screens/EventDetailScreen.dart';
import 'package:iplanning/screens/mainScreen/LoginScreen.dart';
import 'package:iplanning/screens/mainScreen/createEventScreens.dart';
import 'package:iplanning/screens/listEventUser.dart';
import 'package:iplanning/screens/mainScreen/profileScreen.dart';
import 'package:iplanning/screens/wishlist.dart';
import 'package:iplanning/services/cloud.service.dart';
import 'package:iplanning/services/noti.service.dart';
import 'package:iplanning/widgets/InvitewithFriends.dart';
import 'package:iplanning/widgets/buildDrawTile.dart';
import 'package:iplanning/widgets/cardCustom.dart';
import 'package:iplanning/widgets/categories.dart';
import 'package:iplanning/services/auth.service.dart';
import 'package:iplanning/widgets/topSection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreens extends StatefulWidget {
  const Homescreens({super.key});

  @override
  State<Homescreens> createState() => _HomescreensState();
}

class _HomescreensState extends State<Homescreens> {
  List RandomImages = [];
  late AlarmNotifier _alarmNotifier;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserModel? _userData;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<EventsPostModel>? _eventPosts;
  EventsPostModel? event;
  List<CategoryModel>? _categoriesModel;
  String? _selectedCategoryId;
  final _authService = AuthenticationService();
  final _eventService = ClouMethods();
  Timer? _eventTimer;
  bool _isLoading = true;
  bool inviting = false;
  int inviters = 0;
  double? _paidAmount;
  bool _isLoadingEvents = false;
  String? _lastNotifiedEventId;

  @override
  void initState() {
    _alarmNotifier = AlarmNotifier(FlutterLocalNotificationsPlugin());
    _reqPermissionNotification();
    // TODO: implement initState
    super.initState();
    _loadData().then((value) {
      if (event != null) {
        _getDataPicture();
      }
    });
    _loadPostEvent().then(((value) async {
      _getDataPicture();
      _checkForUpcomingEvents();
    }));
    _getDataPicture();
    _startEventCountdown();
    _initializeData();
  }

  Future<void> _reqPermissionNotification() async {
    await _alarmNotifier.requestNotificationsPermission();
  }

  Future<void> _initializeData() async {
    await _loadData();
    await _checkForUpcomingEvents();
    _startEventCountdown();
  }

  Future<void> _loadData() async {
    await _loadUserData();
    await _loadPostEvent().then((value) {
      if (event != null) {}
    });
    await _loadCategories();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    UserModel? userData = await _authService.getUserData();
    if (mounted) {
      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    }
  }

// !Load Events
  Future<void> _loadPostEvent() async {
    setState(() {
      _isLoading = true;
    });
    firestoreInstance
        .collection('eventPosts')
        .orderBy('createAt', descending: true)
        .snapshots()
        .listen((snapshot) async {
      List<EventsPostModel> events = snapshot.docs.map((doc) {
        return EventsPostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      final latestEventId = events.isNotEmpty ? events.first.event_id : null;
      print("latestEventId $latestEventId");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? lastNotifiedEventId = prefs.getString('lastNotifiedEventId');
      print("lastNotifiedEventId $lastNotifiedEventId");
      if (latestEventId != null && latestEventId != lastNotifiedEventId) {
        final currentUserId = authInstance.currentUser!.uid == events.first.uid;
        // if (currentUserId) {
        //   AlarmNotifier.showNotification(
        //     flutterLocalNotificationsPlugin,
        //     '${events.first.event_name} đã được đăng!',
        //     '${events.first.event_name} đã được đăng!',
        //     events.first.event_id,
        //   );
        // } else {
        //   AlarmNotifier.showNotification(
        //     flutterLocalNotificationsPlugin,
        //     'Bài viết mới',
        //     'Sự kiện "${events.first.event_name}" đã được đăng!',
        //     events.first.event_id,
        //   );
        // }
        await prefs.setString('lastNotifiedEventId', latestEventId);
      }
      setState(() {
        _eventPosts = events;
        print("Loaded events: ${_eventPosts!.length}");
        if (_eventPosts != null && _eventPosts!.isNotEmpty) {
          event = _eventPosts!.first;
          _getDataPicture();
        }
      });
    });
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _startEventCountdown() async {
    _eventTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkForUpcomingEvents();
    });
  }

  Future<void> _checkForUpcomingEvents() async {
    if (_eventPosts == null || _eventPosts!.isEmpty) {
      return;
    }

    if (_eventPosts == null || _eventPosts!.isEmpty) {
      return;
    }

    _eventPosts!.forEach((event) {
      final eventStartTime = event.eventDateStart.toDate();
    });

    final upcomingEvent = _eventPosts!.where((event) {
      final eventStartTime = event.eventDateStart.toDate();
      final now = DateTime.now();
      final timeUntilEvent = eventStartTime.difference(now).inMinutes;
      print("Time until ${event.event_name}: $timeUntilEvent minutes");
      return timeUntilEvent > 0 && timeUntilEvent <= 10;
    }).toList();

    if (upcomingEvent.isNotEmpty) {
      final now = DateTime.now();
      final eventStartTime = upcomingEvent.first.eventDateStart.toDate();
      final timeUntilEvent = eventStartTime.difference(now).inMinutes;

      if (timeUntilEvent > 0 && timeUntilEvent <= 10) {
        // AlarmNotifier.showNotification(
        //     flutterLocalNotificationsPlugin,
        //     'Sự kiện sắp bắt đầu!',
        //     'Còn $timeUntilEvent phút nữa sự kiện "${upcomingEvent.first.event_name}" sẽ bắt đầu lúc ${eventStartTime.hour}:${eventStartTime.minute}',
        //     upcomingEvent.first.event_id);
      }
    } else {
      print("No upcoming events within the next 10 minutes.");
    }
  }

  void _filterEventsByCategory(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _isLoadingEvents = true;
    });
    _loadEventsForCategory(categoryId).then((events) {
      setState(() {
        _eventPosts = events;
        _isLoadingEvents = false;
      });
    });
  }

  List<EventsPostModel> _filterEventsWithLocation(
      List<EventsPostModel> events) {
    return events.where((event) => event.location!.isNotEmpty).toList();
  }

// !filter category
  Future<List<EventsPostModel>> _loadEventsForCategory(
      String categoryId) async {
    CategoryModel? selectedCategory = _categoriesModel
        ?.firstWhere((category) => category.category_id == categoryId);
    if (selectedCategory != null && selectedCategory.event_ids!.isEmpty) {
      print(selectedCategory.event_ids);
      return [];
    }
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('eventPosts')
        .where('event_id', whereIn: selectedCategory?.event_ids)
        .get();
    List<EventsPostModel> events = querySnapshot.docs.map((doc) {
      return EventsPostModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
    return events;
  }

  void _checkInviteStatus() async {
    DocumentSnapshot eventSnapshot = await firestoreInstance
        .collection('eventPosts')
        .doc(event!.event_id)
        .get();

    setState(() {
      inviting = (eventSnapshot.data() as dynamic)['isPending']
          .contains(authInstance.currentUser!.uid);
    });
  }

  Future<List<CategoryModel>> _loadCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await firestoreInstance.collection('categoriesEvent').get();

      List<CategoryModel> categoryModel = querySnapshot.docs.map((doc) {
        return CategoryModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      setState(() {
        _categoriesModel = categoryModel;
      });
      return _categoriesModel!;
    } catch (e) {
      return [];
    }
  }

  void resetEvents() {
    setState(() {
      _selectedCategoryId = null;
      _loadPostEvent();
    });
  }

  Future<void> _getDataPicture() async {
    setState(() {
      _isLoading = true;
    });

    DocumentSnapshot eventSnapshot = await firestoreInstance
        .collection('eventPosts')
        .doc(event != null ? event!.event_id : '')
        .get();
    if (eventSnapshot.exists && eventSnapshot.data() != null) {
      List<dynamic> acceptedUser =
          (eventSnapshot.data() as dynamic)['isAccepted'] ?? [];

      List<String> avatars = [];

      for (String userIds in acceptedUser) {
        DocumentSnapshot userSnapshot =
            await firestoreInstance.collection('users').doc(userIds).get();

        if (userSnapshot.exists && userSnapshot.data() != null) {
          String? avatarUrl = (userSnapshot.data() as dynamic)['newAvatars'] ??
              (userSnapshot.data() as dynamic)['avatars'];
          if (avatarUrl != null) {
            avatars.add(avatarUrl);
          }
        }
      }

      setState(() {
        RandomImages = avatars;
        inviters = acceptedUser.length;
        _isLoading = false;
      });

      print("RandomImages: $RandomImages");
      print("Number of inviters: $inviters");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    List<EventsPostModel> filteredEvents = _selectedCategoryId != null
        ? _filterEventsWithLocation(
            (_eventPosts ?? []).where((event) {
              return _categoriesModel!
                  .firstWhere(
                      (category) => category.category_id == _selectedCategoryId)
                  .event_ids!
                  .contains(event.event_id);
            }).toList(),
          )
        : _filterEventsWithLocation(_eventPosts ?? []);

    return Scaffold(
      key: _scaffoldKey,
      drawer: (_userData == null)
          ? const Center(child: CircularProgressIndicator())
          : Drawer(
              child: Column(
                children: [
                  DrawerHeader(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(),
                      child: TextButton(
                        onPressed: () {},
                        child: ListTile(
                          onTap: () {
                            _scaffoldKey.currentState?.closeDrawer();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => ProfileScreen(
                                          enteredemail: _userData!.email,
                                          username: _userData!.name,
                                          avatarEdit: _userData!.displayAvatar,
                                          country: _userData!.country,
                                          phoneNumber: _userData!.phone,
                                          userData: _userData!,
                                        )));
                          },
                          title: Row(
                            children: [
                              _userData?.displayAvatar != null
                                  ? CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage(
                                          _userData!.displayAvatar!),
                                    )
                                  : CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage(
                                          'https://thumbs.dreamstime.com/b/profile-anonymous-face-icon-gray-silhouette-person-male-default-avatar-photo-placeholder-white-background-vector-illustration-106473768.jpg'),
                                    ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      _userData!.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05, // Responsive font size
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _userData!.email,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                  buildDrawerTile(
                    context: context,
                    icon: Icons.event_sharp,
                    title: 'Tạo Kế Hoạch',
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => CreateEventScreens(
                                    uid: _userData!.uid,
                                    avatar: _userData!.displayAvatar,
                                    username: _userData!.name,
                                    list: _categoriesModel ?? [],
                                  )));
                      if (result == true) {
                        _loadPostEvent();
                        _loadCategories();
                      }
                    },
                    scaffoldKey: _scaffoldKey,
                  ),
                  buildDrawerTile(
                    context: context,
                    icon: Icons.event_sharp,
                    title: 'Kế hoạch của tôi',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => ListEvent()));
                    },
                    scaffoldKey: _scaffoldKey,
                  ),
                  buildDrawerTile(
                    context: context,
                    icon: Icons.bookmark,
                    title: 'Mục yêu thích',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => WishListScreen(
                                    event_id:
                                        event != null ? event!.event_id : null,
                                  )));
                    },
                    scaffoldKey: _scaffoldKey,
                  ),
                  buildDrawerTile(
                    context: context,
                    icon: Icons.person,
                    title: 'Cá nhân',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => ProfileScreen(
                                    enteredemail: _userData!.email,
                                    username: _userData!.name,
                                    avatarEdit: _userData!.displayAvatar,
                                    country: _userData!.country,
                                    phoneNumber: _userData!.phone,
                                    userData: _userData!,
                                  )));
                    },
                    scaffoldKey: _scaffoldKey,
                  ),
                  buildDrawerTile(
                    context: context,
                    icon: Icons.chat_bubble,
                    title: 'Gemini',
                    onTap: () {},
                    scaffoldKey: _scaffoldKey,
                  ),
                  buildDrawerTile(
                    context: context,
                    icon: Icons.send,
                    title: 'Phản hồi',
                    onTap: () {},
                    scaffoldKey: _scaffoldKey,
                  ),
                  buildDrawerTile(
                    context: context,
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      authInstance.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Loginscreen()),
                      );
                    },
                    scaffoldKey: _scaffoldKey,
                  ),
                ],
              ),
            ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xff4A43EC),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(50))),
            height: MediaQuery.of(context).size.height < 700
                ? MediaQuery.of(context).size.height * 0.35
                : MediaQuery.of(context).size.height * 0.27,
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.height < 700
                    ? MediaQuery.of(context).size.height * 0.24
                    : MediaQuery.of(context).size.height * 0.19,
                elevation: 0,
                backgroundColor: Color(0xff4A43EC),
                flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                  return FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: constraints.biggest.height < 120 ? 1 : 0,
                      ),
                      background: TopSection(
                        drawer: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        location: _userData?.country ?? '',
                        eventId: event != null ? event!.event_id : '',
                        getPicture: _getDataPicture,
                        onFilter: () {},
                      ));
                }),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: screenHeight < 700
                          ? screenHeight * 0.13
                          : screenHeight * 0.09,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40)),
                      // !CategoriesSection
                      child: CategoriesSection(
                        categories: _categoriesModel ?? [],
                        onCategorySelected: (categoryId) {
                          _filterEventsByCategory(categoryId);
                          _loadEventsForCategory(categoryId).then((events) {
                            setState(() {
                              _eventPosts = events;
                            });
                          });
                        },
                        onAllEvents: () {
                          resetEvents();
                        },
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                              horizontal: screenWidth * 0.05,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    'Khám phá kế hoạch',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => AllEventScreen(
                                                  paidAmount: _paidAmount,
                                                )));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      'Xem tất cả',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: _isLoadingEvents
                                ? Container()
                                : (filteredEvents.isEmpty ||
                                        _eventPosts == null ||
                                        _eventPosts!.isEmpty ||
                                        event?.event_id == null)
                                    ? Center(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                            child: Text(
                                              'No Events Available',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: _eventPosts!.map((event) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (event != null &&
                                                  event?.uid != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        Eventdetailscreen(
                                                      uid: event.uid,
                                                      titleEvent:
                                                          event.event_name,
                                                      userName: event.username,
                                                      location: event.location!,
                                                      startDate:
                                                          event.eventDateStart,
                                                      avartar: event
                                                              .profilePic ??
                                                          'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg',
                                                      discription: event
                                                              .description ??
                                                          'không có nội dung ở đây',
                                                      backgroundIMG:
                                                          event.eventImage![0],
                                                      event_id: event.event_id,
                                                    ),
                                                  ),
                                                ).then((value) {
                                                  if (value == true) {
                                                    _loadPostEvent();
                                                  }
                                                });
                                              } else {
                                                print(
                                                    "Event or event UID is null");
                                              }
                                            },
                                            child: CardCustom(
                                              event: event,
                                              RandomImages: RandomImages,
                                              uid: _userData != null
                                                  ? _userData!.uid
                                                  : '',
                                              count: event.invitersCount,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                          ),
                          Invitewithfriends(),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width,
                          //   height: 100,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
