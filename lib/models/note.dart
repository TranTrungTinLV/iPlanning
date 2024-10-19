import 'package:iplanning/utils/transactionType.dart';
import 'package:uuid/uuid.dart';

class NoteModel {
  final String name;
  final String note_id;
  final String budget_id;
  final TransactionType transactionType;
  final String? content;
  NoteModel({
    required this.name,
    this.content,
    required this.budget_id,
    required this.note_id,
    required this.transactionType,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      name: json['name'] as String,
      note_id: json['note_id'] as String,
      budget_id: json['budget_id'] as String,
      content: json['content'] as String?,
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
      'budget_id': budget_id,
      'transactionType': transactionType.toString()
    };
  }
}
