import 'package:testing_listviewer/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/study/section_model.dart';
import '../providers/study_data_provider.dart';
import 'jelly_button.dart';
import '../screens/stage_screen.dart';

class SectionWidget extends StatefulWidget {
  final SectionModel section;
  final int sectionIndex;

  const SectionWidget({
    super.key,
    required this.section,
    required this.sectionIndex,
  });

  @override
  State<SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  @override
  void initState() {
    super.initState();
    // Register the section's stage count with the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudyDataProvider>().setSectionStageCount(
            widget.sectionIndex,
            widget.section.stages.length,
          );
    });
  }

  void _navigateToStage(BuildContext context, int stageIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StageScreen(
          sectionIndex: widget.sectionIndex,
          stageIndex: stageIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [];

    // final offsets = [0.0, 20.0, 30.0, 20.0, 0.0, -20.0, -30.0, -20.0];
    final offsets = [0.0, 25.0, 40.0, 25.0, 0.0, -25.0, -40.0, -25.0];
    // final offsets = [0.0, 5.0, 8.0, 5.0, 0.0, -5.0, -8.0, -5.0]; // percentage
    final reverseOffsets = offsets.map((offset) => -offset).toList();
    final adjustedOffsets =
        (widget.sectionIndex % 2 == 1) ? reverseOffsets : offsets;

    for (int i = 0; i < widget.section.stages.length; i++) {
      double offsetPercent = (i == 0 || i == widget.section.stages.length - 1)
          ? 0
          : adjustedOffsets[i % adjustedOffsets.length];

      bool isMaxOffset = offsetPercent.abs() == 40.0;

      Widget buttonContent = Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.hp(2)),
          child: Align(
            alignment: Alignment(offsetPercent / 100, 0),
            child: JellyButton(
              // label: 'Item ${i + 1}',
              label: widget.section.stages[i].title,
              color: widget.section.color,
              sectionIndex: widget.sectionIndex,
              stageIndex: i,
              onPressed: () => _navigateToStage(context, i),
            ),
          ),
        ),
      );

      if (isMaxOffset) {
        buttonContent = Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            buttonContent,
            Positioned(
              top: null,
              bottom: null,
              left: offsetPercent < 0
                  ? null
                  : SizeConfig.wp(
                      SizeConfig.isLandscape(context) ? 15 : 13,
                    ), // Opposite side
              right: offsetPercent > 0
                  ? null
                  : SizeConfig.wp(SizeConfig.isLandscape(context) ? 15 : 13),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: SizeConfig.wp(
                    SizeConfig.isLandscape(context) ? 20 : 30,
                  ),
                  height: SizeConfig.wp(
                    SizeConfig.isLandscape(context) ? 20 : 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[700],
                    borderRadius: BorderRadius.circular(SizeConfig.wp(2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber[700]!.withAlpha(
                          (0.4 * 255).toInt(),
                        ),
                        blurRadius: SizeConfig.wp(4),
                        spreadRadius: SizeConfig.wp(1),
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'BONUS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }

      buttons.add(buttonContent);
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Column(children: buttons),
      ),
    );
  }
}
