import 'package:flutter/material.dart';
import 'screens/today_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/settings_screen.dart';
import 'models/task.dart';
import 'services/storage_service.dart';

void main() {
  runApp(StudyPlannerApp());
}

class StudyPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Task> _tasks = [];
  bool _remindersEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _checkReminders();
  }

  Future<void> _loadData() async {
    final tasks = await StorageService.loadTasks();
    final remindersEnabled = await StorageService.loadReminderSettings();
    
    setState(() {
      _tasks = tasks;
      _remindersEnabled = remindersEnabled;
    });
  }

  void _checkReminders() {
    if (!_remindersEnabled) return;
    
    final now = DateTime.now();
    final todayTasks = _tasks.where((task) {
      return task.dueDate.year == now.year &&
             task.dueDate.month == now.month &&
             task.dueDate.day == now.day &&
             task.reminderTime != null &&
             !task.isCompleted;
    }).toList();

    if (todayTasks.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showReminderDialog(todayTasks);
      });
    }
  }

  void _showReminderDialog(List<Task> tasks) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('📅 Task Reminders'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: tasks.map((task) => ListTile(
            title: Text(task.title),
            subtitle: Text(task.description ?? ''),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _addTask(Task task) async {
    setState(() {
      _tasks.add(task);
    });
    await StorageService.saveTasks(_tasks);
  }

  Future<void> _updateTask(Task updatedTask) async {
    setState(() {
      final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
    });
    await StorageService.saveTasks(_tasks);
  }

  Future<void> _deleteTask(String taskId) async {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
    });
    await StorageService.saveTasks(_tasks);
  }

  Future<void> _toggleReminders(bool enabled) async {
    setState(() {
      _remindersEnabled = enabled;
    });
    await StorageService.saveReminderSettings(enabled);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      TodayScreen(
        tasks: _tasks,
        onAddTask: _addTask,
        onUpdateTask: _updateTask,
        onDeleteTask: _deleteTask,
      ),
      CalendarScreen(
        tasks: _tasks,
        onAddTask: _addTask,
        onUpdateTask: _updateTask,
        onDeleteTask: _deleteTask,
      ),
      SettingsScreen(
        remindersEnabled: _remindersEnabled,
        onToggleReminders: _toggleReminders,
        taskCount: _tasks.length,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
