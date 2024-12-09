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
import 'package:iplanning/providers/managers/alarm.managers.notifier.dart';
import 'package:iplanning/services/notification.services.dart';
import 'package:iplanning/widgets/InvitewithFriends.dart';
import 'package:iplanning/widgets/buildDrawTile.dart';
import 'package:iplanning/widgets/cardCustom.dart';
import 'package:iplanning/widgets/categories.dart';
import 'package:iplanning/services/auth.service.dart';
import 'package:iplanning/widgets/topSection.dart';

class Homescreens extends StatefulWidget {
  const Homescreens({super.key});

  @override
  State<Homescreens> createState() => _HomescreensState();
}

class _HomescreensState extends State<Homescreens> {
  Map<String, List<String>> eventImages = {};
  late AlarmNotifier _alarmNotifier;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserModel? _userData;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<EventsPostModel>? _eventPosts;
  List<EventsPostModel>? _myEventPosts;
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
    _alarmNotifier =
        AlarmNotifier(NotificationService(FlutterLocalNotificationsPlugin()));
    _reqPermissionNotification();
    // TODO: implement initState
    super.initState();
    _loadData().then((value) {
      if (event != null) {
        _getDataPicture();
      }
    });
    _loadPostEvent().then(((value) async {
      _checkForUpcomingEvents();
    }));
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
    if (_userData == null) {
      print("User data is not available yet");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    FirebaseFirestore.instance
        .collection('eventPosts')
        .orderBy('createAt', descending: true)
        .snapshots()
        .listen((snapshot) async {
      List<EventsPostModel> events = snapshot.docs.map((doc) {
        return EventsPostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      List<EventsPostModel> myEvents = events.where((event) {
        return event.uid == _userData!.uid;
      }).toList();

      if (mounted) {
        setState(() {
          _eventPosts = events;
          _myEventPosts = myEvents;

          print("Loaded events: ${_eventPosts?.length ?? 0}");
          print("Loaded my events: ${_myEventPosts?.length ?? 0}");

          if (_eventPosts != null && _eventPosts!.isNotEmpty) {
            event = _eventPosts!.first;
            _getDataPicture();
          }
          _isLoading = false;
        });
      }
    }, onError: (error) {
      print("Error loading events: $error");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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

      if (timeUntilEvent > 0 && timeUntilEvent <= 10) {}
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

  Future<List<CategoryModel>> _loadCategories() async {
    try {
      QuerySnapshot querySnapshot = await firestoreInstance
          .collection('categoriesEvent')
          .orderBy('createAt', descending: true)
          .get();

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

    try {
      for (var event in _eventPosts ?? []) {
        List<String> avatars = [];

        DocumentSnapshot<Map<String, dynamic>> eventSnapshot =
            await FirebaseFirestore.instance
                .collection('eventPosts')
                .doc(event.event_id)
                .get();

        if (!eventSnapshot.exists) {
          print("Event document does not exist for ID: ${event.event_id}");
          eventImages[event.event_id] = [];
          continue;
        }

        List<String>? acceptedUsers =
            (eventSnapshot.data()?['isAccepted'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList();

        if (acceptedUsers == null || acceptedUsers.isEmpty) {
          print("No users in 'isAccepted' for Event ID: ${event.event_id}");
          eventImages[event.event_id] = [];
          continue;
        }

        for (String userId in acceptedUsers) {
          try {
            DocumentSnapshot<Map<String, dynamic>> userSnapshot =
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get();

            if (userSnapshot.exists) {
              String? avatarUrl = userSnapshot.data()?['avatars'] ??
                  userSnapshot.data()?['newAvatars'];
              if (avatarUrl != null && avatarUrl.isNotEmpty) {
                avatars.add(avatarUrl);
              }
            }
          } catch (e) {
            print("Error fetching user data for User ID: $userId");
          }
        }

        // Lưu danh sách ảnh vào map
        eventImages[event.event_id] = avatars;
      }

      setState(() {
        _isLoading = false;
      });

      print("Updated events with avatars.");
    } catch (e) {
      print("Error in _getDataPicture: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    List<EventsPostModel> filteredEvents = _selectedCategoryId != null
        ? _eventPosts!.where((event) {
            return _categoriesModel!
                .firstWhere(
                    (category) => category.category_id == _selectedCategoryId)
                .event_ids!
                .contains(event.event_id);
          }).toList()
        : _eventPosts ?? [];

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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => ListEvent(
                                    RandomImages:
                                        eventImages[event!.event_id] ?? [],
                                  )));
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
                                    RandomImages:
                                        eventImages[event!.event_id] ?? [],
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
          RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.blue,
            strokeWidth: 2.0,
            onRefresh: () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await _loadData();
              } catch (error) {
                print("Error refreshing data: $error");
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: CustomScrollView(
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
                          counter_notifi: (_myEventPosts != null &&
                                  _myEventPosts!.isNotEmpty)
                              ? _myEventPosts!
                                  .where((event) =>
                                      event.isPending != null &&
                                      event.isPending!.isNotEmpty)
                                  .length
                              : 0,
                          drawer: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          location: _userData?.country ?? '',
                          eventId: event != null ? event!.event_id : '',
                          getPicture: _getDataPicture,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Kế hoạch của bản thân',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => ListEvent(
                                            RandomImages: (_myEventPosts !=
                                                        null &&
                                                    _myEventPosts!.isNotEmpty)
                                                ? eventImages[_myEventPosts!
                                                        .first.event_id] ??
                                                    []
                                                : [],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Xem tất cả',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035,
                                          color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: _myEventPosts == null ||
                                        _myEventPosts!.isEmpty
                                    ? Container(
                                        width: screenWidth,
                                        child: Center(
                                          child: Text(
                                            'Không có kế hoạch nào.',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                          ),
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                            children:
                                                _myEventPosts!.map((event) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      Eventdetailscreen(
                                                    loadData: () {
                                                      print("đã load lại nà");
                                                      _loadCategories();
                                                      _loadPostEvent();
                                                    },
                                                    endDate: event.eventDateEnd,
                                                    RandomImages: eventImages[
                                                            event.event_id] ??
                                                        [],
                                                    uid: event.uid,
                                                    titleEvent:
                                                        event.event_name,
                                                    userName: event.username,
                                                    location: event.location ??
                                                        'Không có địa điểm',
                                                    startDate:
                                                        event.eventDateStart,
                                                    avartar: event.profilePic ??
                                                        'https://example.com/default-avatar.png',
                                                    discription:
                                                        event.description ??
                                                            'Không có mô tả',
                                                    backgroundIMG: event
                                                                .eventImage
                                                                ?.isNotEmpty ==
                                                            true
                                                        ? event.eventImage![0]
                                                        : 'https://example.com/default-image.png',
                                                    event_id: event.event_id,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: CardCustom(
                                              event: event,
                                              RandomImages:
                                                  eventImages[event.event_id] ??
                                                      [],
                                              uid: _userData != null
                                                  ? _userData!.uid
                                                  : '',
                                              count: event.invitersCount,
                                            ),
                                          );
                                        }).toList()))),

                            Container(
                              margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                                horizontal: screenWidth * 0.05,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      'Khám phá kế hoạch',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => AllEventScreen(
                                                    RandomImages: eventImages[
                                                            _eventPosts!.first
                                                                .event_id] ??
                                                        [],
                                                    paidAmount: _paidAmount,
                                                  )));
                                    },
                                    child: Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'Xem tất cả',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                            color: Colors.blue),
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Center(
                                              child: Text(
                                                _selectedCategoryId != null
                                                    ? 'Không có kế hoạch  trong danh mục ${_categoriesModel?.firstWhere((category) => category.category_id == _selectedCategoryId).name}.'
                                                    : 'Không có kế hoạch nào.',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize:
                                                        _selectedCategoryId !=
                                                                null
                                                            ? screenWidth * 0.04
                                                            : screenWidth *
                                                                0.045),
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
                                                        loadData: () {
                                                          print(
                                                              "đã load lại nà");
                                                          _loadCategories();
                                                          _loadPostEvent();
                                                        },
                                                        RandomImages:
                                                            eventImages[event
                                                                    .event_id] ??
                                                                [],
                                                        uid: event.uid,
                                                        titleEvent:
                                                            event.event_name,
                                                        userName:
                                                            event.username,
                                                        location:
                                                            event.location!,
                                                        endDate:
                                                            event.eventDateEnd,
                                                        startDate: event
                                                            .eventDateStart,
                                                        avartar: event
                                                                .profilePic ??
                                                            'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg',
                                                        discription: event
                                                                .description ??
                                                            'không có nội dung ở đây',
                                                        backgroundIMG: event
                                                            .eventImage![0],
                                                        event_id:
                                                            event.event_id,
                                                      ),
                                                    ),
                                                  ).then((value) {
                                                    if (value == true) {
                                                      _loadPostEvent();
                                                      _loadCategories();
                                                    }
                                                  });
                                                } else {
                                                  print(
                                                      "Event or event UID is null");
                                                }
                                              },
                                              child: CardCustom(
                                                event: event,
                                                RandomImages: eventImages[
                                                        event.event_id] ??
                                                    [],
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
          ),
        ],
      ),
    );
  }
}
