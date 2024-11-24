// import 'package:flutter/material.dart';
// import 'package:iplanning/widgets/filterbutton.dart';

// class SearchAndFilterRow extends StatelessWidget {
//   SearchAndFilterRow({super.key, required this.onFilter});
//   final void Function() onFilter;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             autocorrect: false,
//             decoration: InputDecoration(
//               prefixIcon: const Icon(Icons.search),
//               prefixIconColor: Colors.white,
//               border: InputBorder.none,
//               hintText: 'Search...',
//               contentPadding:
//                   const EdgeInsets.symmetric(vertical: 15), // Căn giữa văn bản

//               hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
//               // filled: true,
//               fillColor: Colors.transparent,
//             ),
//           ),
//         ),
//         const SizedBox(width: 20),
//         FilterButton(
//           onFilter: onFilter,
//         ),
//       ],
//     );
//   }
// }
