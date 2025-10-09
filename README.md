# Study Planner App

A Flutter mobile application for managing study tasks with calendar integration and reminder system.

## Features

### ✅ Task Management
- Create tasks with title, description, due date, and reminder time
- View today's tasks on dedicated screen
- Mark tasks as completed
- Delete tasks with confirmation dialog

### ✅ Calendar View
- Monthly calendar displaying all days
- Visual highlighting of dates with tasks
- Tap any date to view tasks for that day
- Add tasks directly from calendar

### ✅ Reminder System
- Set reminder times for tasks
- Popup notifications when app opens
- Toggle reminders on/off in settings

### ✅ Local Storage
- Tasks persist after app restart
- Uses SharedPreferences for data storage
- Reliable data persistence

### ✅ Navigation & UI
- Bottom navigation with 3 screens (Today, Calendar, Settings)
- Clean Material Design interface
- Responsive layout for portrait/landscape

## Project Structure

```
lib/
├── main.dart                 # App entry point and main navigation
├── models/
│   └── task.dart            # Task data model
├── screens/
│   ├── today_screen.dart    # Today's tasks view
│   ├── calendar_screen.dart # Calendar with task highlighting
│   └── settings_screen.dart # App settings
├── services/
│   └── storage_service.dart # SharedPreferences storage
└── widgets/
    ├── task_item.dart       # Individual task display
    └── add_task_dialog.dart # Task creation dialog
```

## Dependencies

- `shared_preferences: ^2.2.2` - Local data storage
- `table_calendar: ^3.0.9` - Calendar widget

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Screenshots

The app includes:
- Today screen with task list
- Calendar view with task highlighting
- Settings screen with reminder toggle
- Task creation and deletion dialogs

## Technical Implementation

- **State Management**: StatefulWidget with setState
- **Storage**: SharedPreferences with JSON serialization
- **Navigation**: BottomNavigationBar with screen switching
- **UI**: Material Design components (Scaffold, AppBar, ListTile, etc.)
- **Date Handling**: DateTime and TimeOfDay pickers