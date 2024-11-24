import 'package:flutter/material.dart';
import 'package:iplanning/widgets/Dashboard.dart';
import 'package:iplanning/widgets/searchandfilter.dart';

class TopSection extends StatefulWidget {
  TopSection(
      {super.key,
      required this.drawer,
      required this.eventId,
      required this.getPicture,
      required this.location,
      required this.onFilter});
  final void Function() drawer;
  final void Function() getPicture;
  final String eventId;
  final String location;
  final void Function() onFilter;

  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  @override
  Widget build(BuildContext context) {
    return
        // SingleChildScrollView(
        Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: EdgeInsets.only(top: 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TopBar(
            location: widget.location,
            drawer: widget.drawer,
            eventId: widget.eventId,
            getPicture: widget.getPicture,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          // SearchAndFilterRow(
          //   onFilter: widget.onFilter,
          // ),
        ],
      ),
    );
    // );
  }
}
