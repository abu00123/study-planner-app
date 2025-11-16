import 'package:flutter_test/flutter_test.dart';
import 'package:study_planner_app/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Task creation with required fields', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        dueDate: DateTime(2024, 1, 1),
      );

      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.dueDate, DateTime(2024, 1, 1));
      expect(task.description, null);
      expect(task.reminderTime, null);
      expect(task.isCompleted, false);
    });

    test('Task JSON serialization and deserialization', () {
      final originalTask = Task(
        id: '123',
        title: 'JSON Test',
        description: 'Testing JSON conversion',
        dueDate: DateTime(2024, 6, 15, 14, 30),
        reminderTime: DateTime(2024, 6, 15, 9, 0),
        isCompleted: true,
      );

      final json = originalTask.toJson();
      final deserializedTask = Task.fromJson(json);

      expect(deserializedTask.id, originalTask.id);
      expect(deserializedTask.title, originalTask.title);
      expect(deserializedTask.description, originalTask.description);
      expect(deserializedTask.dueDate, originalTask.dueDate);
      expect(deserializedTask.reminderTime, originalTask.reminderTime);
      expect(deserializedTask.isCompleted, originalTask.isCompleted);
    });

    test('Task copyWith method', () {
      final originalTask = Task(
        id: '1',
        title: 'Original',
        dueDate: DateTime(2024, 1, 1),
      );

      final updatedTask = originalTask.copyWith(
        title: 'Updated',
        isCompleted: true,
      );

      expect(updatedTask.id, originalTask.id);
      expect(updatedTask.title, 'Updated');
      expect(updatedTask.dueDate, originalTask.dueDate);
      expect(updatedTask.isCompleted, true);
    });
  });
}