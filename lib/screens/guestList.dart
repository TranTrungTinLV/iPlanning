import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/services/cloud.service.dart';
import 'package:iplanning/utils/dialog.dart';
import 'package:iplanning/widgets/GuestListItems.dart';

class GuestList extends StatefulWidget {
  GuestList({super.key, required this.eventId});
  final eventId;

  @override
  State<GuestList> createState() => _GuestListState();
}

class _GuestListState extends State<GuestList> {
  Map<String, String?> inviteStatus = {};
  bool isLoading = true;
  List<UserModel> userList = [];
  String searchInput = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAllInviteStatuses();
  }

  void _loadAllInviteStatuses() async {
    QuerySnapshot usersSnapshot = await firestoreInstance
        .collection('users')
        .where('uid', isNotEqualTo: authInstance.currentUser?.uid)
        .get();

    userList = usersSnapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    for (var user in userList) {
      final status = await _getInviteStatus(user.uid);
      setState(() {
        inviteStatus[user.uid] = status;
        print("Invite status updated for user ${user.uid}: $status");
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<String?> _getInviteStatus(String userId) async {
    DocumentSnapshot eventSnapshot = await firestoreInstance
        .collection('eventPosts')
        .doc(widget.eventId)
        .get();

    if (eventSnapshot.exists && eventSnapshot.data() != null) {
      var eventData = eventSnapshot.data() as Map<String, dynamic>;
      if (eventData['isAccepted']?.contains(userId) ?? false) {
        return 'isAccepted';
      } else if (eventData['isPending']?.contains(userId) ?? false) {
        return 'isPending';
      } else if (eventData['isRequestInvite']?.contains(userId) ?? false) {
        return 'isRequestInvite';
      } else {
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<UserModel> filteredUsers = userList.where((user) {
      return user.name.toLowerCase().contains(searchInput.toLowerCase());
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest List'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.person_add_alt,
                size: 24,
              )),
        ],
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchInput = value;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Tìm người dùng'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: filteredUsers.isEmpty
                        ? Center(
                            child: Text(
                              'Không tìm thấy người dùng',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              return Guestlistitems(
                                  onStatusChanged: (userId, status) {
                                    setState(() {
                                      inviteStatus[userId] = status;
                                    });
                                  },
                                  inviteStatus: inviteStatus,
                                  users: filteredUsers[index],
                                  eventId: widget.eventId);
                            }),
                  ),
                ],
              ),
            ),
    );
  }
}
