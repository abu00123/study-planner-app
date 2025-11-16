import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';
import '../widgets/add_task_dialog.dart';

class CalendarScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onAddTask;
  final Function(Task) onUpdateTask;
  final Function(String) onDeleteTask;

  const CalendarScreen({
    Key? key,
    required this.tasks,
    required this.onAddTask,
    required this.onUpdateTask,
    required this.onDeleteTask,
  }) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<Task> _getTasksForDay(DateTime day) {
    return widget.tasks.where((task) {
      return task.dueDate.year == day.year &&
             task.dueDate.month == day.month &&
             task.dueDate.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTasks = _getTasksForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TableCalendar<Task>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getTasksForDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: selectedTasks.isEmpty
                ? Center(
                    child: Text(
                      'No tasks for ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: selectedTasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        task: selectedTasks[index],
                        onUpdate: widget.onUpdateTask,
                        onDelete: widget.onDeleteTask,
                        onEdit: (task) => _showEditTaskDialog(task),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAddTask: widget.onAddTask,
        initialDate: _selectedDay,
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAddTask: widget.onUpdateTask,
        initialDate: task.dueDate,
        editingTask: task,
      ),
    );
  }
}