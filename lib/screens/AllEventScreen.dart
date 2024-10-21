import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/screens/EventDetailScreen.dart';

class AllEventScreen extends StatefulWidget {
  AllEventScreen({
    super.key,
    required this.paidAmount,
  });
  double? paidAmount;
  UserModel? userProfile;
  @override
  State<AllEventScreen> createState() => _AllEventScreenState();
}

class _AllEventScreenState extends State<AllEventScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Events"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('eventPosts').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
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

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => Eventdetailscreen(
                                    uid: event.uid,
                                    titleEvent: event.event_name,
                                    userName: event.username,
                                    location: event.location,
                                    startDate: event.eventDateStart,
                                    avartar: event.profilePic,
                                    discription: event.description!,
                                    backgroundIMG: event.eventImage![0],
                                    event_id: event.event_id,
                                  )));
                    },
                    child: Card(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 92,
                              width: 79,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                            Container(
                              margin: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${event.eventDateStart.toDate().day}-${event.eventDateStart.toDate().month}-${event.eventDateStart.toDate().year} ${event.eventDateStart.toDate().hour}:${event.eventDateStart.toDate().minute}",
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xff5669FF)),
                                  ),
                                  Text(
                                    event.event_name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 14,
                                          color: Colors.grey.shade700),
                                      SizedBox(
                                        width: 6.0,
                                      ),
                                      Text(
                                        event.location,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
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
    );
  }
}
