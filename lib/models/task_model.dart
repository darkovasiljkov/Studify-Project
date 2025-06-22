class Task {
  final String title;
  final String description;
  final String dueDate;
  final String priority;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
  });

  // Firebase methods
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['dueDate'] ?? '',
      priority: map['priority'] ?? '',
    );
  }
}
