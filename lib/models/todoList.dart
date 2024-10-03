class ToDoList {
  String title;
  bool completed;
  String details;

  ToDoList(this.title, this.completed, this.details);
  factory ToDoList.fromMap(Map<String, dynamic> json) {
    return ToDoList(
      json['title'] as String,
      json['completed'] as bool,
      json['details'] as String,
    );
  }
  Map<String, dynamic> toJson() =>
      {'title': title, 'completed': completed, 'details': details};
}
