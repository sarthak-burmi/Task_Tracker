class Task {
  String title;
  String description;
  bool completed;
  DateTime selectedDate;
  String from;
  String to;

  Task({
    required this.title,
    required this.description,
    required this.selectedDate,
    required this.from,
    required this.to,
    this.completed = false,
  });
}
