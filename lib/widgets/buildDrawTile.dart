import 'package:flutter/material.dart';

Widget buildDrawerTile({
  required BuildContext context,
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  required GlobalKey<ScaffoldState> scaffoldKey,
}) {
  return ListTile(
    title: Container(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Icon(icon, size: 30),
          const SizedBox(width: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
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
