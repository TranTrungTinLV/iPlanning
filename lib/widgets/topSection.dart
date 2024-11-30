import 'package:flutter/material.dart';
import 'package:iplanning/widgets/Dashboard.dart';
import 'package:iplanning/widgets/searchandfilter.dart';

class TopSection extends StatefulWidget {
  TopSection({
    super.key,
    required this.drawer,
    required this.counter_notifi,
    required this.eventId,
    required this.getPicture,
    required this.location,
  });
  final void Function() drawer;
  final void Function() getPicture;
  final String eventId;
  final String location;

  final int counter_notifi;
  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      padding: EdgeInsets.only(top: 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TopBar(
            counter_notifi: widget.counter_notifi,
            location: widget.location,
            drawer: widget.drawer,
            eventId: widget.eventId,
            getPicture: widget.getPicture,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
        ],
      ),
    );
    // );
  }
}
