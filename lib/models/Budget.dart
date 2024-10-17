import 'package:iplanning/models/events_model.dart';

class Budget {
  String budget_id;
  String budget_name;
  String? event_id;
  double paidAmount;
  String? note_id;
  Budget(
      {required this.budget_id,
      this.note_id,
      required this.paidAmount,
      required this.event_id,
      required this.budget_name});
  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
        note_id: json['note'] as String?,
        paidAmount: json['paidAmount'] as double,
        event_id: json['event_id'] as String,
        budget_name: json['budget_name'] as String,
        budget_id: json['budget_id'] as String);
  }
  Map<String, dynamic> toJson() => {
        'paidAmount': paidAmount,
        'note_id': note_id,
        'event_id': event_id,
        'budget_name': budget_name
      };
}
