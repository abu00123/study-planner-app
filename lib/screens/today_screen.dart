import 'package:flutter/material.dart';
import '../models/task.dart';

class TodayScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onAddTask;
  final Function(Task) onUpdateTask;
  final Function(String) onDeleteTask;

  const TodayScreen({
    Key? key,
    required this.tasks,
    required this.onAddTask,
    required this.onUpdateTask,
    required this.onDeleteTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayTasks = tasks.where((task) =>
        task.dueDate.year == today.year &&
        task.dueDate.month == today.month &&
        task.dueDate.day == today.day).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Today')),
      body: todayTasks.isEmpty
          ? Center(child: Text('No tasks for today'))
          : ListView.builder(
              itemCount: todayTasks.length,
              itemBuilder: (context, index) {
                final task = todayTasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description ?? ''),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) => onUpdateTask(
                      task.copyWith(isCompleted: value),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task'),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(labelText: 'Task Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final task = Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  dueDate: DateTime.now(),
                );
                onAddTask(task);
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}