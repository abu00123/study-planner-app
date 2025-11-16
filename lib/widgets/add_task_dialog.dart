import 'package:flutter/material.dart';
import '../models/task.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onAddTask;
  final DateTime initialDate;
  final Task? editingTask;

  const AddTaskDialog({
    Key? key,
    required this.onAddTask,
    required this.initialDate,
    this.editingTask,
  }) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    
    if (widget.editingTask != null) {
      final task = widget.editingTask!;
      _titleController.text = task.title;
      _descriptionController.text = task.description ?? '';
      _selectedDate = task.dueDate;
      if (task.reminderTime != null) {
        _reminderTime = TimeOfDay.fromDateTime(task.reminderTime!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editingTask != null;
    
    return AlertDialog(
      title: Text(isEditing ? 'Edit Task' : 'Add New Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Due Date'),
              subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              trailing: Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            ListTile(
              title: Text('Reminder Time'),
              subtitle: Text(_reminderTime != null 
                  ? '${_reminderTime!.hour}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
                  : 'No reminder'),
              trailing: Icon(Icons.access_time),
              onTap: _selectTime,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTask,
          child: Text(isEditing ? 'Update' : 'Save'),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _reminderTime = time);
    }
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Title is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (title.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Title must be less than 100 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    DateTime? reminderDateTime;
    if (_reminderTime != null) {
      reminderDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _reminderTime!.hour,
        _reminderTime!.minute,
      );
      
      // Validate reminder time is not in the past
      if (reminderDateTime.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder time cannot be in the past'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    final description = _descriptionController.text.trim();
    final isEditing = widget.editingTask != null;
    
    final task = Task(
      id: isEditing ? widget.editingTask!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description.isEmpty ? null : description,
      dueDate: _selectedDate,
      reminderTime: reminderDateTime,
      isCompleted: isEditing ? widget.editingTask!.isCompleted : false,
    );

    widget.onAddTask(task);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? 'Task updated successfully' : 'Task added successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}