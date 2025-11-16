import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_planner_app/main.dart';
import 'package:study_planner_app/models/task.dart';

void main() {
  group('StudyPlannerApp Tests', () {
    testWidgets('App loads with bottom navigation', (WidgetTester tester) async {
      await tester.pumpWidget(StudyPlannerApp());
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Can navigate between screens', (WidgetTester tester) async {
      await tester.pumpWidget(StudyPlannerApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Calendar'));
      await tester.pumpAndSettle();
      expect(find.text('Calendar'), findsWidgets);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Enable Reminders'), findsOneWidget);
    });
  });

  group('Task Model Tests', () {
    test('Task creation and JSON serialization', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        dueDate: DateTime(2024, 1, 1),
      );

      expect(task.title, 'Test Task');
      expect(task.isCompleted, false);

      final json = task.toJson();
      final taskFromJson = Task.fromJson(json);
      expect(taskFromJson.title, task.title);
      expect(taskFromJson.id, task.id);
    });

    test('Task copyWith method', () {
      final task = Task(
        id: '1',
        title: 'Original',
        dueDate: DateTime(2024, 1, 1),
      );

      final updatedTask = task.copyWith(isCompleted: true);
      expect(updatedTask.isCompleted, true);
      expect(updatedTask.title, 'Original');
    });
  });
}
