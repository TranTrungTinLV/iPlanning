import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/user_models.dart';
import 'package:iplanning/services/cloud.service.dart';
import 'package:iplanning/utils/dialog.dart';

class Guestlistitems extends StatefulWidget {
  Guestlistitems(
      {super.key,
      required this.users,
      required this.eventId,
      required this.inviteStatus,
      required this.onStatusChanged});
  final UserModel users;
  final String eventId;
  final Map<String, String?> inviteStatus;
  final Function(String, String?) onStatusChanged;

  @override
  State<Guestlistitems> createState() => _GuestlistitemsState();
}

class _GuestlistitemsState extends State<Guestlistitems> {
  String? get inviteStatus => widget.inviteStatus[widget.users.uid];
  final String currentUserId = authInstance.currentUser!.uid;

  void _handleInvite() async {
    final currentStatus = await _getLatestInviteStatus(widget.users.uid);

    if (inviteStatus == null) {
      // Chủ sự kiện mời người dùng
      await ClouMethods().invitedEvents(
        widget.users.uid,
        widget.eventId,
        'isRequestInvite',
      );
      widget.onStatusChanged(widget.users.uid, 'isRequestInvite');
    } else if (inviteStatus == 'isRequestInvite' &&
        widget.users.uid != currentUserId) {
      // Chủ sự kiện hủy mời khi trạng thái là isRequestInvite
      bool shouldReject = await showRejectConfirmationDialog(context);
      if (shouldReject) {
        await ClouMethods().invitedEvents(
          widget.users.uid,
          widget.eventId,
          'isRequestInvite',
        );
        widget.onStatusChanged(widget.users.uid, null);
      }
    } else if (inviteStatus == 'isPending' &&
        widget.users.uid != currentUserId) {
      // Người dùng tự gửi yêu cầu, chủ sự kiện có thể phê duyệt
      bool shouldApprove = await showApproveConfirmationDialog(context);
      if (shouldApprove) {
        await ClouMethods().invitedEvents(
          widget.users.uid,
          widget.eventId,
          'isAccepted',
        );
        widget.onStatusChanged(
            widget.users.uid, 'isAccepted'); // Cập nhật trạng thái trực tiếp
      }
    } else if (inviteStatus == 'isAccepted') {
      bool shouldExit = await showRejectConfirmationDialog(context);
      if (shouldExit) {
        await ClouMethods().invitedEvents(
          widget.users.uid,
          widget.eventId,
          'isRejected',
        );
        widget.onStatusChanged(widget.users.uid, 'isRejected');
      }
    }
  }

  Future<Map<String, dynamic>?> _getLatestInviteStatus(String userId) async {
    DocumentSnapshot eventSnapshot = await firestoreInstance
        .collection('eventPosts')
        .doc(widget.eventId)
        .get();

    if (eventSnapshot.exists && eventSnapshot.data() != null) {
      var eventData = eventSnapshot.data() as Map<String, dynamic>;
      if (eventData['isAccepted']?.contains(userId) ?? false) {
        return {'status': 'isAccepted'};
      } else if (eventData['isPending']?.contains(userId) ?? false) {
        return {'status': 'isPending', 'isUserInitiated': true};
      } else if (eventData['isRequestInvite']?.contains(userId) ?? false) {
        return {'status': 'isRequestInvite', 'isUserInitiated': false};
      } else {
        return null;
      }
    }
    return null;
  }

  Future<bool> showApproveConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Bạn có chắc muốn phê duyệt yêu cầu tham gia?"),
              content: Text("Người dùng này sẽ được chấp nhận vào sự kiện."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Phê duyệt"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<bool> showRejectConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Bạn có chắc muốn hủy lời mời?"),
              content:
                  Text("Người dùng này sẽ không còn được mời vào sự kiện."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Hủy Mời"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    print("Invite status for ${widget.users.uid}: $inviteStatus");

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        key: ValueKey(widget.users.uid),
        margin: EdgeInsets.only(bottom: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22.0,
                  backgroundImage: NetworkImage(widget.users.newAvatars ??
                      'https://i.pinimg.com/236x/46/01/67/46016776db919656210c75223957ee39.jpg'),
                ),
                SizedBox(
                  width: 13,
                ),
                Column(
                  children: [
                    Container(
                      child: Text(
                        widget.users.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: _handleInvite,
              child: Container(
                padding: EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: inviteStatus == 'isAccepted'
                      ? Colors.green
                      : inviteStatus == 'isRequestInvite' &&
                              widget.users.uid != currentUserId
                          ? Colors.red // UnInvite màu đỏ
                          : inviteStatus == 'isPending' &&
                                  widget.users.uid != currentUserId
                              ? Colors.orange // Approve màu cam
                              : Colors.blue,
                ),
                child: Center(
                  child: Text(
                    inviteStatus == 'isAccepted'
                        ? 'Accept'
                        : inviteStatus == 'isRequestInvite' &&
                                widget.users.uid != currentUserId
                            ? 'UnInvite'
                            : inviteStatus == 'isPending' &&
                                    widget.users.uid != currentUserId
                                ? 'Approve'
                                : 'Invite',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
