import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/screens/budgetList.dart';
import 'package:iplanning/screens/budgetScreen.dart';
import 'package:iplanning/screens/guestList.dart';
import 'package:iplanning/widgets/taskList.dart';
import 'package:iplanning/screens/taskScreen.dart';
import 'package:iplanning/services/cloud.service.dart';
import 'package:iplanning/widgets/popUpCustom.dart';
import 'package:popover/popover.dart';

import '../consts/firebase_const.dart';

class ListEvent extends StatefulWidget {
  ListEvent({super.key});

  @override
  State<ListEvent> createState() => _ListEventState();
}

class _ListEventState extends State<ListEvent>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Kế hoạch của tôi'),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            StreamBuilder<QuerySnapshot>(
                stream: firestoreInstance
                    .collection('eventPosts')
                    .where('uid', isEqualTo: authInstance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  int eventCount = 0;
                  if (snapshot.hasData) {
                    eventCount = snapshot.data!.docs.length;
                  }
                  return Tab(
                    child: Container(
                      height: screenHeight * 0.1,
                      child: Column(
                        children: [
                          Text(
                            'All event',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: screenWidth * 0.025),
                          ),
                          Text('${eventCount}',
                              style: TextStyle(fontSize: screenWidth * 0.03)),
                        ],
                      ),
                    ),
                  );
                }),
            StreamBuilder<QuerySnapshot>(
                stream: firestoreInstance
                    .collection('eventPosts')
                    .where('uid', isEqualTo: authInstance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  final accepted = snapshot.data!.docs
                      .where((eventDoc) {
                        final List<dynamic>? isAccepted =
                            eventDoc['isAccepted'];
                        return isAccepted != null && isAccepted.isNotEmpty;
                      })
                      .toList()
                      .length;
                  return Tab(
                    child: Container(
                        height: screenHeight * 0.1,
                        child: Column(
                          children: [
                            Text(
                              'Yes',
                              style: TextStyle(fontSize: screenWidth * 0.03),
                              textAlign: TextAlign.center,
                            ),
                            Text('${accepted}',
                                style: TextStyle(fontSize: screenWidth * 0.03))
                          ],
                        )),
                  );
                }),
            StreamBuilder<QuerySnapshot>(
                stream: firestoreInstance
                    .collection('eventPosts')
                    .where('uid', isEqualTo: authInstance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  final rejected = snapshot.data!.docs
                      .where((eventDoc) {
                        final List<dynamic>? isRejected =
                            eventDoc['isRejected'];
                        return isRejected != null && isRejected.isNotEmpty;
                      })
                      .toList()
                      .length;
                  return Tab(
                    child: Container(
                        height: screenHeight * 0.1,
                        child: Column(
                          children: [
                            Text('No',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: screenWidth * 0.03)),
                            Text('$rejected',
                                style: TextStyle(fontSize: screenWidth * 0.03))
                          ],
                        )),
                  );
                }),
            StreamBuilder<QuerySnapshot>(
                stream: firestoreInstance
                    .collection('eventPosts')
                    .where('uid', isEqualTo: authInstance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  final pending = snapshot.data!.docs
                      .where((eventDoc) {
                        final List<dynamic>? isPending = eventDoc['isPending'];
                        return isPending != null && isPending.isNotEmpty;
                      })
                      .toList()
                      .length;
                  return Tab(
                    child: Container(
                        height: screenHeight * 0.1,
                        child: Column(
                          children: [
                            Text('Not Yet',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: screenWidth * 0.03)),
                            Text('$pending',
                                style: TextStyle(fontSize: screenWidth * 0.03))
                          ],
                        )),
                  );
                }),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_list_alt, size: screenWidth * 0.06),
          ),
        ],
        centerTitle: true,
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: firestoreInstance
                  .collection('eventPosts')
                  .where('uid', isEqualTo: authInstance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Failed to load events: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Events Available'));
                }

                final eventDocs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: eventDocs.length,
                  itemBuilder: (context, index) {
                    final eventDoc = eventDocs[index];
                    final event = EventsPostModel.fromJson(
                        eventDoc.data() as Map<String, dynamic>);

                    return Container(
                      height: screenHeight * 0.15,
                      margin: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.025),
                      child: Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: screenHeight * 0.12,
                              width: screenWidth * 0.2,
                              margin: EdgeInsets.only(left: screenWidth * 0.02),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(screenWidth * 0.025)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      event.eventImage != null &&
                                              event.eventImage!.isNotEmpty
                                          ? event.eventImage![0]
                                          : 'https://via.placeholder.com/150'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: screenWidth * 0.04,
                                    top: screenHeight * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${event.eventDateStart.toDate().day}-${event.eventDateStart.toDate().month}-${event.eventDateStart.toDate().year} ${event.eventDateStart.toDate().hour}:${event.eventDateStart.toDate().minute}",
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.grey),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      event.event_name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: screenHeight * 0.002),
                                    event.location != null
                                        ? Text(
                                            event.location!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.03,
                                                fontWeight: FontWeight.w300),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (BuildContext ctx) => [
                                const PopupMenuItem<String>(
                                    value: 'BudgetList',
                                    child: Text('Budget List')),
                                const PopupMenuItem<String>(
                                    value: 'TaskList',
                                    child: Text('Task List')),
                                const PopupMenuItem<String>(
                                    value: 'GuestList',
                                    child: Text('Guest List')),
                              ],
                              onSelected: (String result) {
                                if (result == 'BudgetList') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => Budgetscreen(
                                              eventId: event.event_id,
                                            )),
                                  );
                                } else if (result == 'TaskList') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => TaskScreen(
                                              budgetId: event.budget,
                                              event_id: event.event_id,
                                            )),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => GuestList(
                                              eventId: event.event_id,
                                            )),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
          StreamBuilder<QuerySnapshot>(
              stream: firestoreInstance
                  .collection('eventPosts')
                  .where('uid', isEqualTo: authInstance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Failed to load events: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Events "Yes" Available'));
                }
                final eventDocsIsAccepted =
                    snapshot.data!.docs.where((eventDoc) {
                  final List<dynamic>? isAccepted = eventDoc['isAccepted'];
                  return isAccepted != null && isAccepted.isNotEmpty;
                }).toList();

                if (eventDocsIsAccepted.isEmpty) {
                  return const Center(child: Text('No Events "Yes" Available'));
                }

                return ListView.builder(
                  itemCount: eventDocsIsAccepted.length,
                  itemBuilder: (context, index) {
                    final eventDoc = eventDocsIsAccepted[index];
                    final event = EventsPostModel.fromJson(
                        eventDoc.data() as Map<String, dynamic>);
                    return Container(
                      height: screenHeight * 0.15,
                      margin: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.025),
                      child: Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: screenHeight * 0.12,
                              width: screenWidth * 0.2,
                              margin: EdgeInsets.only(left: screenWidth * 0.02),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(screenWidth * 0.025)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      event.eventImage != null &&
                                              event.eventImage!.isNotEmpty
                                          ? event.eventImage![0]
                                          : 'https://via.placeholder.com/150'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: screenWidth * 0.04,
                                    top: screenHeight * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${event.eventDateStart.toDate().day}-${event.eventDateStart.toDate().month}-${event.eventDateStart.toDate().year} ${event.eventDateStart.toDate().hour}:${event.eventDateStart.toDate().minute}",
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.grey),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      event.event_name,
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: screenHeight * 0.002),
                                    event.location != null
                                        ? Text(
                                            event.location!,
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w300),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (BuildContext ctx) => [
                                const PopupMenuItem<String>(
                                    value: 'BudgetList',
                                    child: Text('Budget List')),
                                const PopupMenuItem<String>(
                                    value: 'TaskList',
                                    child: Text('Task List')),
                                const PopupMenuItem<String>(
                                    value: 'GuestList',
                                    child: Text('Guest List')),
                              ],
                              onSelected: (String result) {
                                if (result == 'BudgetList') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => Budgetscreen(
                                              eventId: event.event_id,
                                            )),
                                  );
                                } else if (result == 'TaskList') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => TaskScreen(
                                              budgetId: event.budget,
                                              event_id: event.event_id,
                                            )),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => GuestList(
                                              eventId: event.event_id,
                                            )),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
          StreamBuilder<QuerySnapshot>(
              stream: firestoreInstance
                  .collection('eventPosts')
                  .where('uid', isEqualTo: authInstance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Failed to load events: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Events "No" Available'));
                }
                final eventDocsIsRejected =
                    snapshot.data!.docs.where((eventDoc) {
                  final List<dynamic>? isRejected = eventDoc['isRejected'];
                  return isRejected != null && isRejected.isNotEmpty;
                }).toList();

                if (eventDocsIsRejected.isEmpty) {
                  return const Center(child: Text('No Events "No" Available'));
                }

                return ListView.builder(
                  itemCount: eventDocsIsRejected.length,
                  itemBuilder: (context, index) {
                    final eventDoc = eventDocsIsRejected[index];
                    final event = EventsPostModel.fromJson(
                        eventDoc.data() as Map<String, dynamic>);
                    return Container(
                      height: screenHeight * 0.15,
                      margin: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.025),
                      child: Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: screenHeight * 0.12,
                              width: screenWidth * 0.2,
                              margin: EdgeInsets.only(left: screenWidth * 0.02),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(screenWidth * 0.025)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      event.eventImage != null &&
                                              event.eventImage!.isNotEmpty
                                          ? event.eventImage![0]
                                          : 'https://via.placeholder.com/150'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: screenWidth * 0.04,
                                    top: screenHeight * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${event.eventDateStart.toDate().day}-${event.eventDateStart.toDate().month}-${event.eventDateStart.toDate().year} ${event.eventDateStart.toDate().hour}:${event.eventDateStart.toDate().minute}",
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.grey),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      event.event_name,
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: screenHeight * 0.002),
                                    event.location != null
                                        ? Text(
                                            event.location!,
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w300),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (BuildContext ctx) => [
                                const PopupMenuItem<String>(
                                    value: 'BudgetList',
                                    child: Text('Budget List')),
                                const PopupMenuItem<String>(
                                    value: 'TaskList',
                                    child: Text('Task List')),
                                const PopupMenuItem<String>(
                                    value: 'GuestList',
                                    child: Text('Guest List')),
                              ],
                              onSelected: (String result) {
                                if (result == 'BudgetList') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => Budgetscreen(
                                              eventId: event.event_id,
                                            )),
                                  );
                                } else if (result == 'TaskList') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => TaskScreen(
                                              budgetId: event.budget,
                                              event_id: event.event_id,
                                            )),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => GuestList(
                                              eventId: event.event_id,
                                            )),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
          StreamBuilder<QuerySnapshot>(
              stream: firestoreInstance
                  .collection('eventPosts')
                  .where('uid', isEqualTo: authInstance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Failed to load events: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No Events "Not Yet" Available'));
                }
                final eventDocsIsPending =
                    snapshot.data!.docs.where((eventDoc) {
                  final List<dynamic>? isPending = eventDoc['isPending'];
                  return isPending != null && isPending.isNotEmpty;
                }).toList();
                if (eventDocsIsPending.isEmpty) {
                  return const Center(
                      child: Text('No Events "Not Yet" Available'));
                }
                return ListView.builder(
                  itemCount: eventDocsIsPending.length,
                  itemBuilder: (context, index) {
                    final eventDoc = eventDocsIsPending[index];
                    final event = EventsPostModel.fromJson(
                        eventDoc.data() as Map<String, dynamic>);
                    return Container(
                      height: screenHeight * 0.15,
                      margin: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.025),
                      child: Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: screenHeight * 0.12,
                              width: screenWidth * 0.2,
                              margin: EdgeInsets.only(left: screenWidth * 0.02),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(screenWidth * 0.025)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      event.eventImage != null &&
                                              event.eventImage!.isNotEmpty
                                          ? event.eventImage![0]
                                          : 'https://via.placeholder.com/150'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: screenWidth * 0.04,
                                    top: screenHeight * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${event.eventDateStart.toDate().day}-${event.eventDateStart.toDate().month}-${event.eventDateStart.toDate().year} ${event.eventDateStart.toDate().hour}:${event.eventDateStart.toDate().minute}",
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.grey),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      event.event_name,
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: screenHeight * 0.002),
                                    event.location != null
                                        ? Text(
                                            event.location!,
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w300),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (BuildContext ctx) => [
                                const PopupMenuItem<String>(
                                    value: 'BudgetList',
                                    child: Text('Budget List')),
                                const PopupMenuItem<String>(
                                    value: 'TaskList',
                                    child: Text('Task List')),
                                const PopupMenuItem<String>(
                                    value: 'GuestList',
                                    child: Text('Guest List')),
                              ],
                              onSelected: (String result) {
                                if (result == 'BudgetList') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => Budgetscreen(
                                              eventId: event.event_id,
                                            )),
                                  );
                                } else if (result == 'TaskList') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => TaskScreen(
                                              budgetId: event.budget,
                                              event_id: event.event_id,
                                            )),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => GuestList(
                                              eventId: event.event_id,
                                            )),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
        ],
      ),
    );
  }
}
