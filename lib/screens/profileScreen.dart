import 'package:flutter/material.dart';
import 'package:iplanning/screens/editScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                backgroundImage: NetworkImage(
                    'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text('Profile Name'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const EditScreen()),
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
