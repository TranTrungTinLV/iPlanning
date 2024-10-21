import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/screens/editScreen.dart';
import 'package:iplanning/services/auth.dart';

class ProfileScreen extends StatefulWidget {
  UserModel userData;

  ProfileScreen(
      {super.key,
      required this.enteredemail,
      required this.username,
      required this.avatarEdit,
      this.phoneNumber,
      this.country,
      required this.userData});
  final String enteredemail;
  final String username;
  final String? avatarEdit;
  final String? phoneNumber;
  final String? country;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthenticationService();
  UserModel? _userData;
  bool? _isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    var isMe = authInstance.currentUser!.uid == widget.userData.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: widget.avatarEdit != null
                    ? NetworkImage(widget.avatarEdit as String)
                    : NetworkImage(
                        'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Text(widget.username),
            ),
            isMe
                ? GestureDetector(
                    onTap: () {
                      final result = Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => EditScreen(
                                  enteremail: widget.enteredemail,
                                  fisrtName: widget.username,
                                  avatarEdit: widget.avatarEdit ??
                                      'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg',
                                  phoneNumber: widget.phoneNumber,
                                  country: widget.country,
                                  userData: widget.userData,
                                  // userData: _userData!,
                                )),
                      );
                    },
                    child: Container(
                      // margin: EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: const Color(0xff5669FF),
                              strokeAlign: 2.0)),

                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  )
                : Container(
                    child: Row(
                    children: <Widget>[],
                  )),
          ],
        ),
      ),
    );
  }
}
