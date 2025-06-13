import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import '../providers/study_data_provider.dart';
import '../models/study/study_data_model.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key});

  Future<void> _exportData(BuildContext context) async {
    try {
      final provider = context.read<StudyDataProvider>();
      if (provider.studyData == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No progress data to export')),
          );
        }
        return;
      }

      // Show export options dialog
      final exportOption = await showDialog<ExportOption>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.save),
                title: const Text('Save to Downloads'),
                onTap: () =>
                    Navigator.pop(context, ExportOption.saveToDownloads),
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share File'),
                onTap: () => Navigator.pop(context, ExportOption.share),
              ),
              ListTile(
                leading: const Icon(Icons.save_alt),
                title: const Text('Save and Share'),
                onTap: () => Navigator.pop(context, ExportOption.both),
              ),
            ],
          ),
        ),
      );

      if (exportOption == null) return;

      final jsonString = jsonEncode(provider.studyData!.toJson());
      File? savedFile;

      // Save to Downloads if needed
      if (exportOption == ExportOption.saveToDownloads ||
          exportOption == ExportOption.both) {
        final directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        savedFile =
            File('${directory.path}/study_progress_data_$timestamp.json');
        await savedFile.writeAsString(jsonString);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data exported to Downloads folder')),
          );
        }
      }

      // Share if needed
      if (exportOption == ExportOption.share ||
          exportOption == ExportOption.both) {
        final fileToShare = savedFile ?? await _createTempFile(jsonString);
        await Share.shareXFiles(
          [XFile(fileToShare.path)],
          text: 'Study Progress Data Export',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting data: $e')),
        );
      }
    }
  }

  Future<File> _createTempFile(String content) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/study_progress_data.json');
    await file.writeAsString(content);
    return file;
  }

  Future<void> _importData(BuildContext context) async {
    try {
      // Show confirmation dialog
      final shouldImport = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Import Progress Data'),
          content: const Text(
            'This will overwrite your current progress. Are you sure you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Import'),
            ),
          ],
        ),
      );

      if (shouldImport != true) return;

      // Pick the file
      const typeGroup = XTypeGroup(
        label: 'JSON',
        extensions: ['json'],
      );
      final file = await openFile(acceptedTypeGroups: [typeGroup]);

      if (file == null) return;

      // Read and validate the file
      final jsonString = await File(file.path).readAsString();
      final json = jsonDecode(jsonString);

      // Validate the data structure
      try {
        final importedData = StudyDataModel.fromJson(json);

        // Additional validation if needed
        if (importedData.sections.isEmpty) {
          throw Exception('Imported data has no sections');
        }

        // Update the provider
        final provider = context.read<StudyDataProvider>();
        await provider.importData(importedData);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data imported successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid data format: $e')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error importing data: $e')),
        );
      }
    }
  }

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
              leading: const Icon(Icons.file_download, color: Colors.white),
              title: const Text(
                'Export Progress',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _exportData(context),
            ),
            ListTile(
              leading: const Icon(Icons.file_upload, color: Colors.white),
              title: const Text(
                'Import Progress',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _importData(context),
            ),
            const Divider(),
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

enum ExportOption {
  saveToDownloads,
  share,
  both,
}
