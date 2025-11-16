import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks';
  static const String _remindersEnabledKey = 'reminders_enabled';

  static Future<bool> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = tasks.map((task) => task.toJson()).toList();
      return await prefs.setString(_tasksKey, jsonEncode(tasksJson));
    } catch (e) {
      print('Error saving tasks: $e');
      return false;
    }
  }

  static Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksString = prefs.getString(_tasksKey);

      if (tasksString == null || tasksString.isEmpty) return [];

      final tasksJson = jsonDecode(tasksString) as List;
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      print('Error loading tasks: $e');
      return [];
    }
  }

  static Future<bool> saveReminderSettings(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_remindersEnabledKey, enabled);
    } catch (e) {
      print('Error saving reminder settings: $e');
      return false;
    }
  }

  static Future<bool> loadReminderSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_remindersEnabledKey) ?? true;
    } catch (e) {
      print('Error loading reminder settings: $e');
      return true;
    }
  }

  static Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tasksKey);
      await prefs.remove(_remindersEnabledKey);
      return true;
    } catch (e) {
      print('Error clearing data: $e');
      return false;
    }
  }
}
