import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_data_provider.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.orange),
              title: const Text(
                'Soft Reset Progress',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Reset all stages to initial state',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                context.read<StudyDataProvider>().softReset();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text(
                'Hard Reset Progress',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Clear all data and start fresh',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                context.read<StudyDataProvider>().hardReset();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
