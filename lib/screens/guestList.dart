import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/models/user_models.dart';

class GuestList extends StatefulWidget {
  const GuestList({super.key});

  @override
  State<GuestList> createState() => _GuestListState();
}

class _GuestListState extends State<GuestList> {
  Map<String, bool> inviteStatus = {};

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('uid',
                  isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Failed to load events: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Events Available'));
            }
            final userDocs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: userDocs.length,
              itemBuilder: (context, index) {
                final users = UserModel.fromJson(
                    userDocs[index].data() as Map<String, dynamic>);
                final isInvited = inviteStatus[users.uid] ?? true;
                return Container(
                  margin: EdgeInsets.only(bottom: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22.0,
                            backgroundImage: NetworkImage(users.newAvatars ??
                                'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg'),
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Column(
                            children: [
                              Container(
                                child: Text(
                                  users.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            inviteStatus[users.uid] =
                                !(inviteStatus[users.uid] ?? true);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.blue,
                          ),
                          child: Text(isInvited ? 'Invite' : 'Uninvite'),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
