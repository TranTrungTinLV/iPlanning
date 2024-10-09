import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/screens/EventDetailScreen.dart';
import 'package:iplanning/screens/LoginScreen.dart';
import 'package:iplanning/screens/createEventScreens.dart';
import 'package:iplanning/screens/listEventUser.dart';
import 'package:iplanning/screens/profileScreen.dart';
import 'package:iplanning/screens/wishlist.dart';
import 'package:iplanning/services/cloud.dart';
import 'package:iplanning/widgets/cardCustom.dart';
import 'package:iplanning/widgets/categories.dart';
import 'package:iplanning/services/auth.dart';
import 'package:iplanning/widgets/topSection.dart';

class Homescreens extends StatefulWidget {
  const Homescreens({super.key});

  @override
  State<Homescreens> createState() => _HomescreensState();
}

class _HomescreensState extends State<Homescreens> {
  List RandomImages = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserModel? _userData;
  EventsPostModel? _eventData;
  List<EventsPostModel>? _eventPosts;
  EventsPostModel? event;
  List<CategoryModel>? _categoriesModel;
  String? _selectedCategoryId;
  final _authService = AuthenticationService();
  final _eventService = ClouMethods();
  bool _isLoading = true;
  bool inviting = false;
  int inviters = 0;
  bool _isLoadingEvents = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUserData();
    await _loadPostEvent();
    await _loadCategories();
  }

  Future<void> _loadUserData() async {
    UserModel? userData = await _authService.getUserData();
    if (mounted) {
      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPostEvent() async {
    List<EventsPostModel> events = await _eventService.getAllEventPosts();

    if (mounted) {
      setState(() {
        _eventPosts = events;
        _isLoading = false;
        if (_eventPosts != null && _eventPosts!.isNotEmpty) {
          event = _eventPosts!.first;
          _getDataPicture();
        }
      });
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
    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('eventPosts')
        .doc(event!.event_id)
        .get();

    setState(() {
      inviting = (eventSnapshot.data() as dynamic)['isPending']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    });
  }

  Future<List<CategoryModel>> _loadCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('categoriesEvent').get();

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

  void _getDataPicture() async {
    setState(() {
      _isLoading = true; // Thêm trạng thái để biết đang tải
    });

    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('eventPosts')
        .doc(event!.event_id)
        .get();
    if (eventSnapshot.exists && eventSnapshot.data() != null) {
      List<dynamic> acceptedUser =
          (eventSnapshot.data() as dynamic)['isAccepted'] ?? [];

      print("acceptedUser: $acceptedUser");
      List<String> avatars = [];

      for (String userIds in acceptedUser) {
        // Lấy thông tin người dùng từ Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userIds)
            .get();

        if (userSnapshot.exists && userSnapshot.data() != null) {
          String? avatarUrl = (userSnapshot.data() as dynamic)['newAvatars'] ??
              (userSnapshot.data() as dynamic)['avatars'];
          if (avatarUrl != null) {
            avatars.add(avatarUrl);
          }
          print(
              "newAvatars: ${(userSnapshot.data() as dynamic)['newAvatars']}");
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
    List<EventsPostModel> filteredEvents = _selectedCategoryId != null
        ? (_eventPosts ?? []).where((event) {
            return _categoriesModel!
                .firstWhere(
                    (category) => category.category_id == _selectedCategoryId)
                .event_ids!
                .contains(event.event_id);
          }).toList()
        : _eventPosts ?? [];

    return Scaffold(
      key: _scaffoldKey,
      drawer: _userData == null
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
                                          _userData!.displayAvatar as String),
                                    )
                                  : const CircleAvatar(
                                      radius: 30.0,
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.person,
                                          color: Colors.white), // Default icon
                                    ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _userData!.name,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    _userData!.email,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                  ListTile(
                    title: Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(children: [
                        const Icon(
                          Icons.event_sharp,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Create Events',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 18,
                              ),
                        ),
                      ]),
                    ),
                    onTap: () async {
                      _scaffoldKey.currentState?.closeDrawer();
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
                      }
                    },
                  ),
                  ListTile(
                    title: Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(children: [
                        const Icon(
                          Icons.event_sharp,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'My Events',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 18,
                              ),
                        ),
                      ]),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => ListEvent()));
                    },
                  ),
                  ListTile(
                    title: Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(children: [
                        const Icon(
                          Icons.bookmark,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'My Wishlist',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 18,
                              ),
                        ),
                      ]),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => WishListScreen(
                                    event_id: event?.event_id ?? '',
                                  )));
                    },
                  ),
                  ListTile(
                    title: Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(children: [
                        const Icon(
                          Icons.person,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Profile',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 18,
                              ),
                        ),
                      ]),
                    ),
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
                  ),
                  ListTile(
                    title: Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(children: [
                        const Icon(
                          Icons.chat_bubble,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Gemini',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 18,
                              ),
                        ),
                      ]),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.send,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Gửi Phản Hồi',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 18,
                                ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.logout,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Đăng xuất',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 18,
                                ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Loginscreen()),
                      );
                    },
                  )
                ],
              ),
            ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Color(0xff4A43EC),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(50))),
            height: MediaQuery.of(context).size.height < 600
                ? MediaQuery.of(context).size.height * 0.24
                : MediaQuery.of(context).size.height * 0.27,
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false, //remove icon Drawer
                pinned: true,
                expandedHeight: 150.0,
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
                        eventId: event != null ? event!.event_id : '',
                      ));
                }),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                          // color: Colors.white,
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
                            margin: const EdgeInsets.symmetric(
                                vertical: 23, horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  child: const Text(
                                    'Upcoming Events',
                                    style: TextStyle(fontSize: 24.0),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print('See all');
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    child: const Text(
                                      'See alls.',
                                      style: TextStyle(fontSize: 14.0),
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
                                  : filteredEvents.isEmpty
                                      ? Center(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                        // isLoadingInvite: _isLoading,
                                                        uid: event.uid,
                                                        titleEvent:
                                                            event.event_name,
                                                        userName:
                                                            event.username,
                                                        location:
                                                            event.location,
                                                        startDate:
                                                            event.createAt,
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
                                                    }
                                                  });
                                                } else {
                                                  // Handle the case when `event` or `event.uid` is null.
                                                  print(
                                                      "Event or event UID is null");
                                                }
                                              },
                                              child: CardCustom(
                                                event: event,
                                                RandomImages: RandomImages,
                                                uid: _userData!.uid,
                                                count: inviters,
                                              ),
                                            );
                                          }).toList())
                              // : Center(
                              //     child: Container(
                              //       width:
                              //           MediaQuery.of(context).size.width,
                              //       child: Center(
                              //         child: Text(
                              //           'No Events Available',
                              //           style: TextStyle(
                              //               color: Colors.red,
                              //               fontSize: 20.0),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: const Color(0xffD6FEFF),
                                borderRadius: BorderRadius.circular(10)),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: ClipRRect(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Invite Your Friend',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const Text(
                                        'Gửi đây 100k',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 15),
                                          decoration: BoxDecoration(
                                              color: const Color(0xff00F8FF),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          padding: const EdgeInsets.all(10),
                                          child: const Text(
                                            'Invite',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    widthFactor: 0.65, // Giới hạn chiều rộng
                                    heightFactor: 0.9, // Giới hạn chiều cao
                                    child: Transform.rotate(
                                      angle: -pi / 6,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        // height: 200,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                          image: AssetImage(
                                              'assets/logo_invite.png'),
                                          fit: BoxFit.contain,
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ),
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
