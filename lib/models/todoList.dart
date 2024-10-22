class ToDoList {
  String title;
  bool completed;
  String details;
  String event_id;
  ToDoList(this.title, this.completed, this.details, this.event_id);
  factory ToDoList.fromMap(Map<String, dynamic> json) {
    return ToDoList(
      json['title'] as String,
      json['completed'] as bool,
      json['details'] as String,
      json['event_id'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
        'title': title,
        'completed': completed,
        'details': details,
        'event_id': event_id
      };
}
