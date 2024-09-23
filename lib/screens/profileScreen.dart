import 'package:flutter/material.dart';
import 'package:iplanning/screens/editScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen(
      {super.key,
      required this.enteredemail,
      required this.username,
      required this.avatarEdit,
      this.phoneNumber,
      this.country});
  final String enteredemail;
  final String username;
  final String? avatarEdit;
  final String? phoneNumber;
  final String? country;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: avatarEdit != null
                    ? NetworkImage(avatarEdit!)
                    : NetworkImage(
                        'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(username),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => EditScreen(
                            enteremail: enteredemail,
                            fisrtName: username.substring(0, 2),
                            lastName: username.substring(username.length - 1),
                            avatarEdit: avatarEdit!,
                            phoneNumber: phoneNumber,
                            country: country,
                          )),
                );
              },
              child: Container(
                // margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(color: Color(0xff5669FF), strokeAlign: 2.0)),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
