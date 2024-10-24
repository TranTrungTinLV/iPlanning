import 'package:flutter/material.dart';
import 'package:iplanning/screens/taskList.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({super.key, required this.budgetId});
  final String budgetId;
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
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

                              )));
                  if (res == "success") {
                      
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Color(0xffF0534F),
                      ),
                      Text(
                        "Add List",
                        style:
                            TextStyle(fontSize: 18, color: Color(0xffF0534F)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
