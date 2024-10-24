import 'package:iplanning/utils/todoStatus.dart';

class TodoModel {
  String title;
  TodoStatus completed;
  String todoId;
  double amount;
  String details;
  String budget_id;
  String? note_id;

  TodoModel({
    required this.amount,
    required this.title,
    required this.completed,
    required this.details,
    required this.budget_id,
    this.note_id,
    required this.todoId,
  });
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      budget_id: json['budget_id'] as String,
      title: json['title'] as String,
      completed: TodoStatus.values.firstWhere(
        (e) => e.toString() == json['completed'],
      ),
      details: json['details'] as String,
      note_id: json['note_id'] as String?,
      todoId: json['todoId'] as String,
      amount: (json['amount'] ?? 0.0) as double,
    );
  }
  Map<String, dynamic> toJson() => {
        'title': title,
        'completed': completed.toString(),
        'details': details,
        'budget_id': budget_id,
        'note_id': note_id,
        'todoId': todoId,
        'amount': amount
      };
}
