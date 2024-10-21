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
              child: Text(
                widget.username,
                style: TextStyle(fontSize: 24),
              ),
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
                            color: const Color(0xff5669FF), strokeAlign: 2.0),
                      ),

                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    '350',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Following',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 80,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    '346',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Follower',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 130,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_add_alt_1,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Follow",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 130,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.messenger_outline_sharp,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Center(
                                      child: Text(
                                        'Message',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
          ],
        ),
      ),
    );
  }
}
