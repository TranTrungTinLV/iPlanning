import 'package:iplanning/utils/todoStatus.dart';

class TodoModel {
  String title;
  TodoStatus completed;
  String todoId;
  double amount;
  String details;

  String? note_id;
  String event_ids;
  TodoModel({
    required this.event_ids,
    required this.amount,
    required this.title,
    required this.completed,
    required this.details,
    this.note_id,
    required this.todoId,
  });
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      title: json['title'] as String,
      completed: TodoStatus.values.firstWhere(
        (e) => e.toString() == json['completed'], // Convert string to enum
      ),
      details: json['details'] as String,
      note_id: json['note_id'] as String?,
      todoId: json['todoId'] as String,
      amount: (json['amount'] ?? 0.0) as double,
      event_ids: json['event_ids'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
        'title': title,
        'completed': completed.toString(),
        'details': details,
        'note_id': note_id,
        'todoId': todoId,
        'amount': amount,
        'event_ids': event_ids,
      };
}
