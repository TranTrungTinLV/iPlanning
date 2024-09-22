import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/screens/LoginScreen.dart';
import 'package:iplanning/screens/createEventScreens.dart';
import 'package:iplanning/screens/profileScreen.dart';
import 'package:iplanning/widgets/Dashboard.dart';
import 'package:iplanning/widgets/categoriesUI.dart';
import 'package:iplanning/widgets/filterbutton.dart';
import 'package:iplanning/widgets/searchandfilter.dart';
import 'package:iplanning/widgets/topSection.dart';

class Homescreens extends StatefulWidget {
  const Homescreens({super.key});

  @override
  State<Homescreens> createState() => _HomescreensState();
}

class _HomescreensState extends State<Homescreens> {
  List RandomImages = [
    'https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg',
    'https://pbs.twimg.com/profile_images/1249432648684109824/J0k1DN1T_400x400.jpg',
    'https://i0.wp.com/thatrandomagency.com/wp-content/uploads/2021/06/headshot.png?resize=618%2C617&ssl=1',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaOjCZSoaBhZyODYeQMDCOTICHfz_tia5ay8I_k3k&s'
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(),
                child: TextButton(
                  onPressed: () {
                    // print("Đăng nhập");
                  },
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => ProfileScreen()));
                    },
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(
                              'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg'),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tín Trần",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "trantintin1989@gmail.com",
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
            ListTile(
              title: Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(children: [
                  Icon(
                    Icons.event_sharp,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Create Events',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 18,
                        ),
                  ),
                ]),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => CreateEventScreens()));
              },
            ),
            ListTile(
              title: Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(children: [
                  Icon(
                    Icons.person,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 18,
                        ),
                  ),
                ]),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => ProfileScreen()));
              },
            ),
            ListTile(
              title: Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(children: [
                  Icon(
                    Icons.chat_bubble,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Gemini',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 18,
                        ),
                  ),
                ]),
              ),
              onTap: () {},
            ),
            ListTile(
              title: Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.send,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Gửi Phản Hồi',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
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
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Đăng xuất',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 18,
                          ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Loginscreen()),
                );
              },
            )
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
            height: 240,
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false, //remove icon Drawer
                pinned: true,
                expandedHeight: 150.0,
                elevation: 0,
                backgroundColor: const Color(0xff4A43EC),
                flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                  return FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: constraints.biggest.height < 120 ? 1 : 0,
                      ),
                      background: TopSection(
                        drawer: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ));
                }),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      // width: MediaQuery.of(context).size.width * 0.9,
                      // margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(40)),
                      child: CategoriesSection(),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 23, horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    'Upcoming Events',
                                    style: TextStyle(fontSize: 24.0),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print('See all');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      'See alls.',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print('Card event upcoming');
                            },
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                  ),
                                  CardCustom(RandomImages: RandomImages),
                                  CardCustom(RandomImages: RandomImages),
                                  CardCustom(RandomImages: RandomImages),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 25),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Color(0xffD6FEFF),
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
                                      Text(
                                        'Invite Your Friend',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        'Gửi đây 100k',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 15),
                                          decoration: BoxDecoration(
                                              color: Color(0xff00F8FF),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          padding: EdgeInsets.all(10),
                                          child: Text(
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
                                        decoration: BoxDecoration(
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

class CardCustom extends StatelessWidget {
  const CardCustom({
    super.key,
    required this.RandomImages,
  });

  final List RandomImages;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.4,
      margin: EdgeInsets.only(right: 10.0),
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
                          fit: BoxFit.cover,
                          repeat: ImageRepeat.noRepeat,
                          image: NetworkImage(
                              'http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcRvC27D9KlxeEham1w-Wpd_pu3hd4A-OywxRbdnx9JFLpcTD7dfL0bD_WI6Ro8QkzrPLkBMzA9osrMpi4JSP5Y'))),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'International Band Mu...',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment:
                        //     MainAxisAlignment
                        //         .spaceBetween,
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Row(
                            children: [
                              for (int i = 0; i < RandomImages.length; i++)
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 0),
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
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              '+20 Going',
                              style: TextStyle(
                                  color: Color(0xff3F38DD), fontSize: 15),
                            ),
                          ),
                          SizedBox()
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('36 Guild Street London, UK'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          SizedBox(width: 10),
          CategoriesUI(
            icons: Icons.sports,
            titleCate: 'Sports',
            colour: Colors.red,
            textColour: Colors.white,
            iconColour: Colors.white,
          ),
          CategoriesUI(
            icons: Icons.sports,
            titleCate: 'Sports',
            colour: Colors.orange,
            textColour: Colors.white,
            iconColour: Colors.white,
          ),
          CategoriesUI(
            icons: Icons.sports,
            titleCate: 'Sports',
            colour: Colors.green,
            textColour: Colors.white,
            iconColour: Colors.white,
          ),
          CategoriesUI(
            icons: Icons.sports,
            titleCate: 'Sports',
            colour: Colors.blueAccent,
            textColour: Colors.white,
            iconColour: Colors.white,
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
