class Budget {
  double budget;
  double paidAmount;
  String note;
  Budget(this.budget, this.note, this.paidAmount);
  Map<String, dynamic> toJson() =>
      {'budget': budget, 'paidAmount': paidAmount, 'note': note};
}
