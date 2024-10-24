import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iplanning/services/todoList.dart';
import 'package:iplanning/utils/todoStatus.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';

class TaskList extends StatefulWidget {
  TaskList({super.key, required this.budget_id, required this.event_id});
  final String budget_id;
  final String event_id;
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TextEditingController taskName = TextEditingController();
  TextEditingController enterNote = TextEditingController();
  TextEditingController amount = TextEditingController();
  bool isLoading = true;

  createTask() async {
    try {
      double? amountValue = double.tryParse(amount.text);
      String res = await TodoListMethod().createTaskWithTodo(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldCustom(
                    controller: taskName,
                    title: 'Task Name',
                    labelText: 'Task Name',
                    bottom: 26,
                    radius: 10.0,
                  ),
                  TextFieldCustom(
                    controller: enterNote,
                    title: 'Enter Note',
                    labelText: 'Enter Note',
                    radius: 10.0,
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldCustom(
                          controller: amount,
                          title: 'Amount',
                          labelText: 'Amount',
                          radius: 10.0,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  print("taskList");
                  createTask();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Center(
                      child: Text(
                    'Add To Task List',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                      color: Color(0xffF0534F),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
