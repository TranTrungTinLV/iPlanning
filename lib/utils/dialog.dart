import 'package:flutter/material.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Bạn có chắc muốn thoát?"),
              content: Text(""),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffE9EFF2),
                      ),
                      padding: EdgeInsetsDirectional.all(10),
                      child: Text("Back")),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            );
          }) ??
      false;
}
