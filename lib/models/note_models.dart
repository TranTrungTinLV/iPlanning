import 'package:iplanning/utils/transactionType.dart';

class NoteModel {
  final String name;
  final String note_id;
  final String budget_id;
  final TransactionType transactionType;
  final double amount;
  final String? content;
  String? todo_id;
  NoteModel({
    required this.name,
    required this.amount,
    this.content,
    this.todo_id,
    required this.budget_id,
    required this.note_id,
    required this.transactionType,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      name: json['name'] as String,
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] ?? 0.0) as double,
      note_id: json['note_id'] as String,
      budget_id: json['budget_id'] as String,
      content: json['content'] as String?,
      todo_id: json['todo_id'] as String?,
      transactionType: TransactionType.values.firstWhere(
        (e) =>
            e.toString() == json['transactionType'], // Convert string to enum
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'note_id': note_id,
      'content': content,
      'amount': amount,
      'budget_id': budget_id,
      'transactionType': transactionType.toString(),
      'todo_id': todo_id,
    };
  }
}
