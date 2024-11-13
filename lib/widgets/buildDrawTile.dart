import 'package:flutter/material.dart';

Widget buildDrawerTile({
  required BuildContext context,
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  required GlobalKey<ScaffoldState> scaffoldKey,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  return ListTile(
    title: Container(
      padding: EdgeInsets.only(left: screenWidth * 0.05),
      child: Row(
        children: [
          Icon(icon, size: screenWidth * 0.07),
          SizedBox(width: screenWidth * 0.05),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
    onTap: () {
      scaffoldKey.currentState?.closeDrawer();
      onTap();
    },
  );
}
