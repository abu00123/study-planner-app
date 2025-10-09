import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool remindersEnabled;
  final Function(bool) onToggleReminders;
  final int taskCount;

  const SettingsScreen({
    Key? key,
    required this.remindersEnabled,
    required this.onToggleReminders,
    required this.taskCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Enable Reminders'),
            value: remindersEnabled,
            onChanged: onToggleReminders,
          ),
          ListTile(
            title: Text('Storage Method'),
            subtitle: Text('SharedPreferences'),
          ),
          ListTile(
            title: Text('Total Tasks'),
            subtitle: Text('$taskCount tasks'),
          ),
        ],
      ),
    );
  }
}