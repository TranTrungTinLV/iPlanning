import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/services/cloud.dart';

class ListEvent extends StatelessWidget {
  ListEvent({super.key, required this.userId});
  // final item;
  final _eventService = ClouMethods();
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Event'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<EventsPostModel>>(
          future: _eventService.getUserEventsByUserId(userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<EventsPostModel> events = snapshot.data!;

            return Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    dynamic data = snapshot.data!;
                    dynamic item = data.docs[index];
                    return Text(item['description']);
                  }),
            );
          }),
    );
  }
}
