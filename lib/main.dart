import 'package:flutter/material.dart';
import 'storage/notes_storage.dart';
import 'theme.dart';
import 'screens/calendar_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_screen.dart';

enum AppThemeMode { system, light, dark }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotesStorage.init();
  runApp(const AmbCalendarApp());
}

class AmbCalendarApp extends StatefulWidget {
  const AmbCalendarApp({super.key});
  @override
  State<AmbCalendarApp> createState() => _AmbCalendarAppState();
}

class _AmbCalendarAppState extends State<AmbCalendarApp> {
  AppThemeMode themeMode = AppThemeMode.system;

  ThemeMode get _mode => switch (themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AmbCalendar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _mode,
      initialRoute: '/',
      routes: {
        '/': (_) => const CalendarScreen(),
        '/settings': (_) => SettingsScreen(
              current: themeMode,
              onChanged: (m) => setState(() => themeMode = m),
            ),
        '/about': (_) => const AboutScreen(),
      },
    );
  }
}