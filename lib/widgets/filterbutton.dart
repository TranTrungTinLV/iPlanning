// import 'dart:ui';

// import 'package:flutter/material.dart';

// class FilterButton extends StatefulWidget {
//   FilterButton({super.key, required this.onFilter});
//   final void Function() onFilter;
//   @override
//   State<FilterButton> createState() => _FilterButtonState();
// }

// class _FilterButtonState extends State<FilterButton> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           height: 32,
//           width: 75,
//           decoration: const BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(50))),
//           child: ClipRect(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
//               child: Container(
//                 height: 32,
//                 width: 75,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(30)),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: widget.onFilter,
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.filter_list,
//                   size: 24,
//                   color: Colors.white,
//                 ),
//                 SizedBox(
//                   width: 3,
//                 ),
//                 Text(
//                   'Lọc',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 12.03),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
