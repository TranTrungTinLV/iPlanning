class Budget {
  double budget;
  double paidAmount;
  String note;
  Budget(this.budget, this.note, this.paidAmount);
  factory Budget.fromMap(Map<String, dynamic> json) {
    return Budget(
      json['budget'] as double,
      json['note'] as String,
      json['paidAmount'] as double,
    );
  }
  Map<String, dynamic> toJson() =>
      {'budget': budget, 'paidAmount': paidAmount, 'note': note};
}
