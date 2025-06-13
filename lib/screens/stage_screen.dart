import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_data_provider.dart';

class StageScreen extends StatelessWidget {
  final int sectionIndex;
  final int stageIndex;

  const StageScreen({
    super.key,
    required this.sectionIndex,
    required this.stageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<StudyDataProvider>(
      builder: (context, provider, child) {
        final section = provider.sections[sectionIndex];
        final stage = section.stages[stageIndex];

        return Scaffold(
          appBar: AppBar(
            title:
                Text('Stage ${stageIndex + 1} - Section ${sectionIndex + 1}'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Section ${section.id} - ${stage.title}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      provider.completeStage(section.id, stage.id);
                      Navigator.pop(context);
                    },
                    child: const Text('Complete Stage'),
                  ),
                ])
              ],
            ),
          ),
        );
      },
    );
  }
}
