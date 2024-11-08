import 'package:flutter/material.dart';
import 'package:iplanning/widgets/Dashboard.dart';
import 'package:iplanning/widgets/searchandfilter.dart';

class TopSection extends StatefulWidget {
  TopSection(
      {super.key,
      required this.drawer,
      required this.eventId,
      required this.getPicture,
      required this.location});
  final void Function() drawer;
  final void Function() getPicture;
  final String eventId;
  final String location;
  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TopBar(
              location: widget.location,
              drawer: widget.drawer,
              eventId: widget.eventId,
              getPicture: widget.getPicture,
            ),
            const SizedBox(height: 20),
            const SearchAndFilterRow(),
          ],
        ),
      ),
    );
  }
}
