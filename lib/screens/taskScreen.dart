import 'package:flutter/material.dart';
import 'package:iplanning/models/todoList.dart';
import 'package:iplanning/screens/taskList.dart';
import 'package:iplanning/services/todoList.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({super.key, required this.budgetId, required this.event_id});
  final String budgetId;
  final String event_id;
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<TodoModel> todoModels = [];
  Future<void> _loadNoteModel() async {
    final task = await TodoListMethod().getAllList(widget.event_id);
    setState(() {
      todoModels = task;
    });
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
        title: Text(
          'Task',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: todoModels.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Text(todoModels[index].title),
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
                      if (res == "success") {}
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
                            style: TextStyle(
                                fontSize: 18, color: Color(0xffF0534F)),
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
    );
  }
}
