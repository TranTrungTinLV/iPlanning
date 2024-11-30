import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/todo_models.dart';
import 'package:iplanning/services/task.service.dart';
import 'package:iplanning/utils/todoStatus.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';

class TaskList extends StatefulWidget {
  TaskList({super.key, this.budget_id, required this.event_id});
  final String? budget_id;
  final String event_id;
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TextEditingController taskName = TextEditingController();
  TextEditingController enterNote = TextEditingController();
  TextEditingController amount = TextEditingController();
  List<Map<String, dynamic>> acceptedUsers = [];
  String? selectedUserId;

  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();

  createTask() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        double? amountValue = double.tryParse(amount.text);
        if (amountValue != null &&
            amountValue > 0 &&
            widget.budget_id == null) {
          Fluttertoast.showToast(
            msg:
                "Budget không tồn tại. Vui lòng tạo budget trước khi thêm khoản chi.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          );
          // return;
        }
        String res = await TodoListMethod().createTaskWithTodo(
          createAt: Timestamp.now(),
          assignedUserId: selectedUserId ?? authInstance.currentUser!.uid,
          budget_id: widget.budget_id,
          content: enterNote.text,
          amount: amountValue ?? 0.0,
          name: taskName.text,
          event_ids: widget.event_id,
        );
        Navigator.of(context).pop(true);
      } catch (e) {
        print("Lỗi");
        print(e);
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchAcceptedUsers(
      List<String> userIds) async {
    try {
      List<Map<String, dynamic>> users = [];
      for (String userId in userIds) {
        DocumentSnapshot userSnapshot =
            await firestoreInstance.collection('users').doc(userId).get();
        if (userSnapshot.exists) {
          users.add(
              {'id': userId, ...userSnapshot.data() as Map<String, dynamic>});
        }
      }
      return users;
    } catch (e) {
      print('Lỗi khi lấy danh sách người dùng: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAcceptedUsers(String eventId) async {
    try {
      DocumentSnapshot eventSnapshot =
          await firestoreInstance.collection('eventPosts').doc(eventId).get();
      if (eventSnapshot.exists) {
        List<dynamic> isAccepted = eventSnapshot['isAccepted'] ?? [];
        if (isAccepted.isNotEmpty) {
          return await fetchAcceptedUsers(isAccepted.cast<String>());
        }
      }
    } catch (e) {
      print('Lỗi khi lấy danh sách người tham gia: $e');
    }
    return [];
  }

  void fetchUsers() async {
    acceptedUsers = await getAcceptedUsers(widget.event_id);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Nhiệm vụ công việc'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldCustom(
                  controller: taskName,
                  title: 'Tên tác vụ',
                  labelText: 'Tên tác vụ',
                  bottom: 26,
                  radius: 10.0,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên tác vụ';
                    }
                    return null;
                  },
                ),
                TextFieldCustom(
                  controller: enterNote,
                  title: 'Thêm ghi chú',
                  labelText: 'Thêm ghi chú',
                  radius: 10.0,
                ),
                SizedBox(
                  height: 26,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFieldCustom(
                        controller: amount,
                        title: 'Chi Phí',
                        labelText: 'Số tiền',
                        radius: 10.0,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButton<String>(
                        underline: SizedBox(),
                        padding: EdgeInsets.only(right: 10, left: 10),
                        value: selectedUserId,
                        items: acceptedUsers.map((user) {
                          return DropdownMenuItem<String>(
                            value: user['uid']
                                as String, // Explicitly cast to String
                            child: Text(
                              user['name'] ?? 'Không có tên',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedUserId = value;
                          });
                        },
                        hint: Text('Chọn người thực hiện'),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                GestureDetector(
                  onTap: () {
                    createTask();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Center(
                        child: Text(
                      'Thêm tác vụ',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
                    decoration: BoxDecoration(
                        color: Color(0xff3D56F0),
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
