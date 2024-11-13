import 'package:flutter/material.dart';
import 'package:iplanning/models/todo_models.dart';
import 'package:iplanning/screens/taskList.dart';
import 'package:iplanning/services/todoList.dart';
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
  bool isChoose = false;
  final _formatterAmount = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

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
          'Danh sách công việc',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          todoModels.isEmpty
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150.0,
                  child: Center(
                      child: Text(
                    "Hiện chưa có danh sách công việc nào",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  )),
                )
              : Container(
                  height: 300,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: todoModels.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                !isChoose
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(right: 3),
                                        child: IconButton(
                                          onPressed: () async {},
                                          icon: Icon(Icons.check),
                                          color: Colors.blue.withOpacity(0.8),
                                        )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        todoModels[index].title,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        todoModels[index]
                                            .completed
                                            .toString()
                                            .split('.')
                                            .last,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            todoModels[index].amount == 0
                                ? Container()
                                : Container(
                                    child: Text(_formatterAmount
                                        .format(todoModels[index].amount)
                                        .replaceAll('.', ',')),
                                  ),
                          ],
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
