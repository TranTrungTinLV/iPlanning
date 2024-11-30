import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iplanning/utils/todoStatus.dart';

class TodoModel {
  String title;
  TodoStatus completed;
  String todoId;
  double amount;
  String details;
  String? imgTask;
  String? description;
  String? note_id;
  String event_ids;
  String assignedUserId;
  Timestamp createAt;
  TodoModel({
    required this.event_ids,
    required this.amount,
    this.description,
    this.imgTask,
    required this.title,
    required this.completed,
    required this.details,
    this.note_id,
    required this.createAt,
    required this.todoId,
    required this.assignedUserId,
  });
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      createAt: json['createAt'] as Timestamp,
      title: json['title'] as String,
      completed: TodoStatus.values.firstWhere(
        (e) => e.toString() == json['completed'], // Convert string to enum
      ),
      imgTask: json['imgTask'] as String?,
      description: json['description'] as String?,
      details: json['details'] as String,
      note_id: json['note_id'] as String?,
      todoId: json['todoId'] as String,
      amount: (json['amount'] ?? 0.0) as double,
      event_ids: json['event_ids'] as String,
      assignedUserId: json['assignedUserId'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
        'title': title,
        'completed': completed.toString(),
        'details': details,
        'note_id': note_id,
        'todoId': todoId,
        'imgTask': imgTask,
        'description': description,
        'amount': amount,
        'event_ids': event_ids,
        'assignedUserId': assignedUserId,
        'createAt': createAt,
      };
}
