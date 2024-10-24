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
      title: json['title'] as String? ??
          'Default', // Kiểm tra null và cung cấp giá trị mặc định
      completed: TodoStatus.values.firstWhere(
        (e) => e.toString() == json['completed'],
        orElse: () =>
            TodoStatus.notStarted, // Giá trị mặc định nếu không tìm thấy
      ),
      details: json['details'] as String? ?? '', // Kiểm tra null
      note_id: json['note_id'] as String? ?? '', // Có thể là null
      todoId: json['todoId'] as String? ??
          '', // Kiểm tra null và cung cấp giá trị mặc định
      amount: (json['amount'] ?? 0.0) as double,
      event_ids: json['event_ids'] is List
          ? (json['event_ids'] as List<dynamic>)
              .join(', ') // Chuyển danh sách thành chuỗi
          : json['event_ids'] as String? ??
              '', // Kiểm tra null và cung cấp giá trị mặc định
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
