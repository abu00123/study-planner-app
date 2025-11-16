import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool remindersEnabled;
  final Function(bool) onToggleReminders;
  final int taskCount;
  final VoidCallback onClearData;

  const SettingsScreen({
    Key? key,
    required this.remindersEnabled,
    required this.onToggleReminders,
    required this.taskCount,
    required this.onClearData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completedTasks = 0; // This would need to be passed from parent
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // App Info Section
          _buildSectionHeader('App Information'),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.blue),
                  title: Text('Study Planner'),
                  subtitle: Text('Version 1.0.0'),
                ),
                ListTile(
                  leading: Icon(Icons.storage, color: Colors.green),
                  title: Text('Storage Method'),
                  subtitle: Text('Local Storage (SharedPreferences)'),
                ),
              ],
            ),
          ),
          
          // Statistics Section
          _buildSectionHeader('Statistics'),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.task_alt, color: Colors.orange),
                  title: Text('Total Tasks'),
                  subtitle: Text('$taskCount tasks created'),
                  trailing: Text(
                    '$taskCount',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.today, color: Colors.purple),
                  title: Text('Today\'s Tasks'),
                  subtitle: Text('Tasks due today'),
                  trailing: Text(
                    _getTodayTaskCount().toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          // Preferences Section
          _buildSectionHeader('Preferences'),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(Icons.notifications, color: Colors.blue),
                  title: Text('Enable Reminders'),
                  subtitle: Text('Show popup reminders when app opens'),
                  value: remindersEnabled,
                  onChanged: onToggleReminders,
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),
          
          // Data Management Section
          _buildSectionHeader('Data Management'),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.delete_forever, color: Colors.red),
                  title: Text('Clear All Data'),
                  subtitle: Text('Delete all tasks and reset settings'),
                  onTap: onClearData,
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          
          // About Section
          _buildSectionHeader('About'),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.help_outline, color: Colors.green),
                  title: Text('Help & Support'),
                  subtitle: Text('Get help using the app'),
                  onTap: () => _showHelpDialog(context),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  leading: Icon(Icons.code, color: Colors.purple),
                  title: Text('Open Source'),
                  subtitle: Text('Built with Flutter'),
                  onTap: () => _showAboutDialog(context),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 32),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
  
  int _getTodayTaskCount() {
    final today = DateTime.now();
    // This is a placeholder - in a real app, you'd filter tasks by today's date
    return 0;
  }
  
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help & Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How to use Study Planner:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Tap + to add new tasks'),
            Text('• Use the calendar to view tasks by date'),
            Text('• Check off completed tasks'),
            Text('• Set reminders for important tasks'),
            Text('• Edit tasks by tapping the edit icon'),
            SizedBox(height: 16),
            Text('Need more help? Contact support at help@studyplanner.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Study Planner',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(Icons.school, size: 48, color: Colors.blue),
      children: [
        Text('A simple and effective task management app for students.'),
        SizedBox(height: 8),
        Text('Built with Flutter and designed for productivity.'),
      ],
    );
  }
}