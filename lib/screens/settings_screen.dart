import 'package:flutter/material.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  final AppThemeMode current;
  final ValueChanged<AppThemeMode> onChanged;
  const SettingsScreen({super.key, required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Тема оформления',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          RadioListTile<AppThemeMode>(
            title: const Text('Системная'),
            secondary: const Icon(Icons.brightness_auto_outlined),
            value: AppThemeMode.system,
            groupValue: current,
            onChanged: (v) => onChanged(v!),
          ),
          RadioListTile<AppThemeMode>(
            title: const Text('Светлая'),
            secondary: const Icon(Icons.light_mode_outlined),
            value: AppThemeMode.light,
            groupValue: current,
            onChanged: (v) => onChanged(v!),
          ),
          RadioListTile<AppThemeMode>(
            title: const Text('Тёмная'),
            secondary: const Icon(Icons.dark_mode_outlined),
            value: AppThemeMode.dark,
            groupValue: current,
            onChanged: (v) => onChanged(v!),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('О программе'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
    );
  }
}