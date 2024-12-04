import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/screens/EventDetailScreen.dart';

class AllEventScreen extends StatefulWidget {
  AllEventScreen({
    super.key,
    required this.paidAmount,
    required this.RandomImages,
  });
  List RandomImages;

  double? paidAmount;
  UserModel? userProfile;
  @override
  State<AllEventScreen> createState() => _AllEventScreenState();
}

class _AllEventScreenState extends State<AllEventScreen> {
  String searchInput = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tất cả kế hoạch"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchInput = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Tìm kiếm sự kiện hoặc tác giả',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreInstance.collection('eventPosts').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child:
                            Text('Failed to load events: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No Events Available'));
                  }
                  final eventDocs = snapshot.data!.docs;
                  final result = eventDocs.where((doc) {
                    final eventName =
                        doc['event_name']?.toString().toLowerCase();
                    final userName = doc['username']?.toString().toLowerCase();
                    return eventName!.contains(searchInput.toLowerCase()) ||
                        userName!.contains(searchInput.toLowerCase());
                  }).toList();
                  return result.isEmpty
                      ? Center(
                          child: Text(
                            'Không tìm thấy sự kiện nào',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      : ListView.builder(
                          itemCount: result.length,
                          itemBuilder: (context, index) {
                            final eventDoc = result[index];
                            final event = EventsPostModel.fromJson(
                                eventDoc.data() as Map<String, dynamic>);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => Eventdetailscreen(
                                              endDate: event.eventDateEnd,
                                              uid: event.uid,
                                              titleEvent: event.event_name,
                                              userName: event.username,
                                              location: event.location!,
                                              startDate: event.eventDateStart,
                                              avartar: event.profilePic,
                                              discription: event.description!,
                                              backgroundIMG:
                                                  event.eventImage![0],
                                              event_id: event.event_id,
                                              RandomImages: widget.RandomImages,
                                            )));
                              },
                              child: Card(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 92,
                                        width: 79,
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(event
                                                            .eventImage !=
                                                        null &&
                                                    event.eventImage!.isNotEmpty
                                                ? event.eventImage![0]
                                                : 'https://via.placeholder.com/150'),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment: (event.location !=
                                                      null &&
                                                  event.location!.isNotEmpty)
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${event.eventDateStart.toDate().day}-${event.eventDateStart.toDate().month}-${event.eventDateStart.toDate().year} ${event.eventDateStart.toDate().hour}:${event.eventDateStart.toDate().minute}",
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                color: Color(0xff5669FF),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Text(
                                                event.event_name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.048,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            (event.location != null &&
                                                    event.location!.isNotEmpty)
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.location_on,
                                                          size: 14,
                                                          color: Colors
                                                              .grey.shade700),
                                                      SizedBox(
                                                        width: 6.0,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                        child: Text(
                                                          event.location!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.035,
                                                              color: Colors.grey
                                                                  .shade700),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
