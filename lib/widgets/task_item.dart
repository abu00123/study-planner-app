import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(Task) onUpdate;
  final Function(String) onDelete;
  final Function(Task)? onEdit;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onUpdate,
    required this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOverdue = !task.isCompleted && task.dueDate.isBefore(DateTime.now());
    
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: task.isCompleted ? 1 : 2,
      color: isOverdue ? Colors.red.shade50 : null,
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) => onUpdate(
            task.copyWith(isCompleted: value ?? false),
          ),
          activeColor: Colors.green,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted 
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
            color: task.isCompleted ? Colors.grey : null,
            fontWeight: isOverdue ? FontWeight.bold : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  task.description!,
                  style: TextStyle(
                    color: task.isCompleted ? Colors.grey : Colors.black87,
                  ),
                ),
              ),
            SizedBox(height: 4),
            Row(
              children: [
                if (task.reminderTime != null) ...[
                  Icon(Icons.access_time, size: 14, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    '${task.reminderTime!.hour}:${task.reminderTime!.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                  SizedBox(width: 12),
                ],
                if (isOverdue) ...[
                  Icon(Icons.warning, size: 14, color: Colors.red),
                  SizedBox(width: 4),
                  Text(
                    'Overdue',
                    style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit!(task),
                tooltip: 'Edit task',
              ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context),
              tooltip: 'Delete task',
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Task'),
          ],
        ),
        content: Text('Are you sure you want to delete "${task.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete(task.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task "${task.title}" deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}