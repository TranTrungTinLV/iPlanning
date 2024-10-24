import 'package:iplanning/utils/todoStatus.dart';

class TodoModel {
  String title;
  TodoStatus completed;
  String todoId;
  double amount;
  String details;
  String event_id;
  String? note_id;
  TodoModel(
      {required this.amount,
      required this.title,
      required this.completed,
      required this.details,
      required this.event_id,
      required this.todoId,
      this.note_id});
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      title: json['title'] as String,
      completed: TodoStatus.values.firstWhere(
        (e) => e.toString() == json['completed'],
      ),
      details: json['details'] as String,
      note_id: json['note_id'] as String?,
      event_id: json['event_id'] as String,
      todoId: json['todoId'] as String,
      amount: json['amount'] ?? 0.0,
    );
  }
  Map<String, dynamic> toJson() => {
        'title': title,
        'completed': completed.toString(),
        'note_id': note_id,
        'details': details,
        'event_id': event_id,
        'todoId': todoId,
        'amount': amount
      };
}
