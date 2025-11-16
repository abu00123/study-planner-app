/// Represents a task in the study planner application.
/// 
/// A task contains essential information like title, due date, and optional
/// fields like description and reminder time. Tasks can be marked as completed.
class Task {
  /// Unique identifier for the task
  final String id;
  
  /// The title/name of the task (required)
  final String title;
  
  /// Optional description providing more details about the task
  final String? description;
  
  /// The date when the task is due (required)
  final DateTime dueDate;
  
  /// Optional reminder time for notifications
  final DateTime? reminderTime;
  
  /// Whether the task has been completed
  final bool isCompleted;

  /// Creates a new Task instance.
  /// 
  /// [id] and [title] and [dueDate] are required.
  /// [description] and [reminderTime] are optional.
  /// [isCompleted] defaults to false.
  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.reminderTime,
    this.isCompleted = false,
  });

  /// Converts the task to a JSON map for storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'reminderTime': reminderTime?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  /// Creates a Task instance from a JSON map.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  /// Creates a copy of this task with optionally updated fields.
  /// 
  /// Only the specified fields will be updated, others remain unchanged.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? reminderTime,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      reminderTime: reminderTime ?? this.reminderTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
