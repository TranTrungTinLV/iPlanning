import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/todo_models.dart';
import 'package:iplanning/utils/todoStatus.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';
import 'package:iplanning/widgets/taskList.dart';
import 'package:iplanning/services/task.service.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({super.key, this.budgetId, required this.event_id});
  final String? budgetId;
  final String event_id;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<TodoModel> todoModels = [];
  late TextEditingController _taskNameController;
  late TextEditingController _amountTaskController;
  File? pickImageFile;
  bool isChoose = false;
  final _formatterAmount = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  bool isSaving = false;
  bool _visible = true;
  Future<void> _loadNoteModel() async {
    try {
      setState(() {
        _visible = true;
      });
      final task = await TodoListMethod().getAllList(widget.event_id);
      setState(() {
        todoModels = task;
        _visible = false;
      });
    } catch (e) {
      setState(() {
        _visible = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        maxWidth: 800,
      );

      if (pickedImage != null) {
        setState(() {
          pickImageFile = File(pickedImage.path);
          print("Có ảnh");
        });
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _updateTodoStatus(String todoId, TodoStatus newStatus,
      {String? description, File? imageFile}) async {
    try {
      String? imageUrl;
      Map<String, dynamic> updateData = {'completed': newStatus.toString()};
      if (description != null) {
        updateData['description'] = description;
      }
      if (imageFile != null) {
        final storageRef = storageInstance
            .ref()
            .child('todo-image')
            .child('todo/${todoId}.png');
        await storageRef.putFile(imageFile);
        imageUrl = await storageRef.getDownloadURL();
        updateData['imgTask'] = imageUrl;
      }
      await TodoListMethod().todoList.doc(todoId).update(updateData);

      setState(() {
        final todo = todoModels.firstWhere((todo) => todo.todoId == todoId);
        todo.completed = newStatus;
        todo.description = description;
        todo.imgTask = imageUrl;
      });
    } catch (e) {
      print('Error updating todo status: $e');
    }
  }

  Future<void> editTask(TodoModel taskModel, String todoId) async {
    await firestoreInstance
        .collection('todos')
        .doc(todoId)
        .update(taskModel.toJson());
  }

  void _showProofDialog(String todoId) {
    final TextEditingController descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            scrollable: true,
            title: Text('Minh chứng?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Nhập mô tả',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  "Hoặc",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                GestureDetector(
                  onTap: () async {
                    await _pickImage();
                    setDialogState(() {});
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff3D56F0)),
                      child: Center(
                          child: Text(
                        'Tải lên hình ảnh',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.white),
                      ))),
                ),
                if (pickImageFile != null)
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    height: 100,
                    child: Image.file(
                      pickImageFile!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (descriptionController.text.isNotEmpty ||
                      pickImageFile != null) {
                    await _updateTodoStatus(todoId, TodoStatus.completed,
                        description: descriptionController.text,
                        imageFile: pickImageFile);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      'Bạn cần nhập mô tả hoặc tải lên hình ảnh!',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                    )));
                  }
                },
                child: Text(
                  'Xác nhận',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  void showPopUpStatus(String todoId, TodoStatus currentStatus) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              scrollable: true,
              title: Text('Thay đổi trạng thái'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: TodoStatus.values.map((status) {
                  return ListTile(
                    title: Text(status.toString().split('.').last),
                    leading: Radio<TodoStatus>(
                      value: status,
                      groupValue: currentStatus,
                      onChanged: (TodoStatus? value) async {
                        if (value != null) {
                          Navigator.of(context).pop();
                          if (value == TodoStatus.completed) {
                            _showProofDialog(todoId);
                          } else {
                            await _updateTodoStatus(todoId, value);
                          }
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNoteModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isChoose = !isChoose;
              });
            },
            child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsetsDirectional.only(end: 20),
                child: Text(
                  !isChoose ? 'Chọn' : "Huỷ",
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
        title: Text(
          'Danh sách việc',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _visible
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : todoModels.isEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150.0,
                        child: Center(
                            child: Text(
                          "Hiện chưa có danh sách công việc nào",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        )),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: todoModels.length,
                          itemBuilder: (context, index) {
                            final todo = todoModels[index];
                            return InkWell(
                              onTap: () {
                                _taskNameController = TextEditingController(
                                    text: todoModels[index].title);
                                _amountTaskController = TextEditingController(
                                  text: NumberFormat.decimalPattern('vi_VN')
                                      .format(todoModels[index].amount)
                                      .replaceAll('.', ','),
                                );
                                showModalBottomSheet(
                                  context: context,
                                  sheetAnimationStyle: AnimationStyle(
                                      duration: Duration(milliseconds: 1000)),
                                  builder: (ctx) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 30),
                                      child: Column(
                                        children: [
                                          TextFieldCustom(
                                            title: 'Tên nhiệm vụ',
                                            controller: _taskNameController,
                                          ),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                          TextFieldCustom(
                                            title: 'Thành tiền',
                                            controller: _amountTaskController,
                                          ),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              todoModels[index].title =
                                                  _taskNameController.text;
                                              todoModels[index]
                                                  .amount = double.tryParse(
                                                      _amountTaskController.text
                                                          .replaceAll(',', '')
                                                          .trim()) ??
                                                  0.0;
                                              await editTask(todoModels[index],
                                                      todoModels[index].todoId)
                                                  .then((_) {
                                                _loadNoteModel();
                                              });
                                              Navigator.of(context).pop();
                                              setState(() {
                                                _loadNoteModel();
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xff3D56F0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: Center(
                                                  child: Text(
                                                'Lưu Thay đổi',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(),
                                      Text(
                                        'Xoá',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                onDismissed: (direction) {
                                  final todoIndex = todoModels[index];

                                  setState(() {
                                    todoModels.removeAt(index);
                                  });

                                  TodoListMethod()
                                      .todoList
                                      .doc(todo.todoId)
                                      .delete();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Công việc đã được xóa!'),
                                      action: SnackBarAction(
                                          label: 'Khôi phục',
                                          onPressed: () {
                                            setState(() {
                                              todoModels.insert(
                                                  index, todoIndex);
                                            });
                                          }),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                },
                                key: ValueKey(todoModels.length),
                                child: Card(
                                  color: todoModels[index].completed ==
                                          TodoStatus.inProgress
                                      ? Colors.yellow[100]
                                      : todoModels[index].completed ==
                                              TodoStatus.canceled
                                          ? Colors.red[100]
                                          : todoModels[index].completed ==
                                                  TodoStatus.completed
                                              ? Colors.green[100]
                                              : null,
                                  child: Container(
                                    // margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            !isChoose
                                                ? Container()
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        right: 3),
                                                    child: IconButton(
                                                      onPressed: () async {},
                                                      icon: Icon(Icons.check),
                                                      color: Colors.blue
                                                          .withOpacity(0.8),
                                                    )),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    todoModels[index].title,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: todoModels[index]
                                                                    .completed ==
                                                                TodoStatus
                                                                    .completed
                                                            ? Colors.green
                                                            : Colors.black,
                                                        decoration: todoModels[
                                                                        index]
                                                                    .completed ==
                                                                TodoStatus
                                                                    .canceled
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : TextDecoration
                                                                .none),
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: () =>
                                                        showPopUpStatus(
                                                            todoModels[index]
                                                                .todoId,
                                                            todoModels[index]
                                                                .completed),
                                                    child: Container(
                                                      child: Text(
                                                        todoModels[index]
                                                            .completed
                                                            .toString()
                                                            .split('.')
                                                            .last,
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ],
                                        ),
                                        todoModels[index].amount == 0
                                            ? Container()
                                            : Container(
                                                child: Text(
                                                  _formatterAmount
                                                      .format(todoModels[index]
                                                          .amount)
                                                      .replaceAll('.', ','),
                                                  style: TextStyle(
                                                      color: todoModels[index]
                                                                  .completed ==
                                                              TodoStatus
                                                                  .completed
                                                          ? Colors.green
                                                          : Colors.black,
                                                      decoration: todoModels[
                                                                      index]
                                                                  .completed ==
                                                              TodoStatus
                                                                  .canceled
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration
                                                              .none),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
              child: Column(
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: () async {
                        final res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => TaskList(
                                      budget_id: widget.budgetId,
                                      event_id: widget.event_id,
                                    )));
                        if (res == true) {
                          _loadNoteModel();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                            color: Color(0xff3D56F0),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Add List",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Color(0xffffffff)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
