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
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      final tasks = await StorageService.loadTasks();
      final remindersEnabled = await StorageService.loadReminderSettings();
      
      setState(() {
        _tasks = tasks;
        _remindersEnabled = remindersEnabled;
        _isLoading = false;
      });
      
      _checkReminders();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
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
    try {
      setState(() {
        _tasks.add(task);
      });
      final success = await StorageService.saveTasks(_tasks);
      if (!success) {
        throw Exception('Failed to save task');
      }
    } catch (e) {
      setState(() {
        _tasks.removeWhere((t) => t.id == task.id);
      });
      _showErrorSnackBar('Failed to add task: $e');
    }
  }

  Future<void> _updateTask(Task updatedTask) async {
    final originalTasks = List<Task>.from(_tasks);
    try {
      setState(() {
        final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
        if (index != -1) {
          _tasks[index] = updatedTask;
        }
      });
      final success = await StorageService.saveTasks(_tasks);
      if (!success) {
        throw Exception('Failed to save task');
      }
    } catch (e) {
      setState(() {
        _tasks = originalTasks;
      });
      _showErrorSnackBar('Failed to update task: $e');
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final originalTasks = List<Task>.from(_tasks);
    try {
      setState(() {
        _tasks.removeWhere((task) => task.id == taskId);
      });
      final success = await StorageService.saveTasks(_tasks);
      if (!success) {
        throw Exception('Failed to save tasks');
      }
    } catch (e) {
      setState(() {
        _tasks = originalTasks;
      });
      _showErrorSnackBar('Failed to delete task: $e');
    }
  }

  Future<void> _toggleReminders(bool enabled) async {
    final originalValue = _remindersEnabled;
    try {
      setState(() {
        _remindersEnabled = enabled;
      });
      final success = await StorageService.saveReminderSettings(enabled);
      if (!success) {
        throw Exception('Failed to save reminder settings');
      }
    } catch (e) {
      setState(() {
        _remindersEnabled = originalValue;
      });
      _showErrorSnackBar('Failed to update reminder settings: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _loadData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading your tasks...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

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
        onClearData: _clearAllData,
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

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Data'),
        content: Text('This will delete all tasks and settings. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await StorageService.clearAllData();
        if (success) {
          setState(() {
            _tasks.clear();
            _remindersEnabled = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('All data cleared successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Failed to clear data');
        }
      } catch (e) {
        _showErrorSnackBar('Failed to clear data: $e');
      }
    }
  }
}
