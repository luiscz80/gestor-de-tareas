class Task {
  final int? id;
  final String title;
  final String description;
  final int categoryId;
  final DateTime date;
  final String priority;
  final String status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.date,
    required this.priority,
    required this.status,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int? ?? 0,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      categoryId: map['categoryId'],
      date: DateTime.parse(map['date'] as String? ?? ''),
      priority: map['priority'] as String? ?? '',
      status: map['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'date': date.toIso8601String(),
      'priority': priority,
      'status': status,
    };
  }
}
