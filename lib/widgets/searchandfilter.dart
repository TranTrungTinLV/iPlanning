import 'package:flutter/material.dart';
import 'package:iplanning/widgets/filterbutton.dart';

class SearchAndFilterRow extends StatelessWidget {
  const SearchAndFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            autocorrect: false,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 20),
        FilterButton(),
      ],
    );
  }
}
