import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/button_state_provider.dart';

class StageScreen extends StatelessWidget {
  final int sectionIndex;
  final int buttonIndex;

  const StageScreen({
    super.key,
    required this.sectionIndex,
    required this.buttonIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stage ${buttonIndex + 1} - Section ${sectionIndex + 1}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Section ${sectionIndex + 1} - Stage ${buttonIndex + 1}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Mark button as completed and enable next button
                    context.read<ButtonStateProvider>().completeButton(
                      sectionIndex,
                      buttonIndex,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
