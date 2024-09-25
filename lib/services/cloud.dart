import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/Budget.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:uuid/uuid.dart';

class ClouMethods {
  CollectionReference postEvents = firestoreInstance.collection('eventPosts');

  uploadPost({
    required String event_name,
    required Timestamp eventDateEnd,
    required Timestamp eventDateStart,
    required String category_id,
    required String event_date,
    required String uid, //user_id
    required String location,
    required String eventImage,
    required Budget budget,
  }) async {
    String res = 'Some Error';

    try {
      String eventId = const Uuid().v4().split('-')[0];
      EventsPostModel eventsPostModel = EventsPostModel(
          event_name: event_name,
          event_id: eventId,
          category_id: category_id,
          uid: uid,
          location: location,
          createAt: Timestamp.now(),
          eventDateEnd: eventDateEnd,
          eventDateStart: eventDateStart,
          eventImage: eventImage,
          budget: budget,
          users: []);
      await postEvents.doc(eventId).set(eventsPostModel.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
