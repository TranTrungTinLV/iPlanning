import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/models/user_models.dart';

class EventState {
  final bool isLoadingInvite;
  final EventsPostModel? eventDetails; // Model chi tiết sự kiện
  final bool? isInvited;
  final double? ammount;
  EventState({
    this.isLoadingInvite = true,
    this.eventDetails,
    this.isInvited,
    this.ammount,
  });

  EventState copyWith({
    bool? isLoadingInvite,
    EventsPostModel? eventDetails,
    bool? isInvited,
    double? ammount,
  }) {
    return EventState(
      isLoadingInvite: isLoadingInvite ?? this.isLoadingInvite,
      eventDetails: eventDetails ?? this.eventDetails,
      isInvited: isInvited ?? this.isInvited,
      ammount: ammount ?? this.ammount,
    );
  }
}

class EventStateNotifier extends StateNotifier<EventState> {
  EventStateNotifier() : super(EventState());

  Future<void> fetchEventById(String eventId) {
    state = state.copyWith(isLoadingInvite: true);
    return FirebaseFirestore.instance
        .collection('eventPosts')
        .doc(eventId)
        .get()
        .then((eventSnapshot) {
      if (eventSnapshot.exists && eventSnapshot.data() != null) {
        final eventData = eventSnapshot.data() as Map<String, dynamic>;

        EventsPostModel eventModel = EventsPostModel.fromJson(eventData);

        state = state.copyWith(
          eventDetails: eventModel,
          isInvited: eventData['isAccepted']
                      ?.contains(FirebaseAuth.instance.currentUser!.uid) ==
                  true
              ? true
              : eventData['isPending']
                          ?.contains(FirebaseAuth.instance.currentUser!.uid) ==
                      true
                  ? false
                  : null,
          ammount: double.tryParse(eventData['budget'] ?? '0'),
          isLoadingInvite: false,
        );
      } else {
        state = state.copyWith(isLoadingInvite: false);
      }
    }).catchError((e) {
      print("Error fetching event: $e");
      state = state.copyWith(isLoadingInvite: false);
    });
  }

  Future<void> refreshEvent(String eventId) {
    return fetchEventById(eventId);
  }
}

final eventStateProvider =
    StateNotifierProvider<EventStateNotifier, EventState>((ref) {
  return EventStateNotifier();
});
