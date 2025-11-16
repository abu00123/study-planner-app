import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';
import '../widgets/add_task_dialog.dart';

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

    final completedTasks = todayTasks.where((task) => task.isCompleted).length;
    final totalTasks = todayTasks.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Today'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: totalTasks > 0 ? PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: totalTasks > 0 ? completedTasks / totalTasks : 0,
            backgroundColor: Colors.blue.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ) : null,
      ),
      body: Column(
        children: [
          if (totalTasks > 0)
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Progress: $completedTasks of $totalTasks tasks completed',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          Expanded(
            child: todayTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No tasks for today',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap + to add your first task',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: todayTasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        task: todayTasks[index],
                        onUpdate: onUpdateTask,
                        onDelete: onDeleteTask,
                        onEdit: (task) => _showEditTaskDialog(context, task),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAddTask: onAddTask,
        initialDate: DateTime.now(),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAddTask: onUpdateTask,
        initialDate: task.dueDate,
        editingTask: task,
      ),
    );
  }
}