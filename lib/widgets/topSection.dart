import 'package:flutter/material.dart';
import 'package:iplanning/widgets/Dashboard.dart';
import 'package:iplanning/widgets/searchandfilter.dart';

class TopSection extends StatefulWidget {
  const TopSection({super.key, required this.drawer});
  final void Function() drawer;
  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TopBar(
            drawer: widget.drawer,
          ),
          SizedBox(height: 20),
          SearchAndFilterRow(),
        ],
      ),
    );
  }
}
