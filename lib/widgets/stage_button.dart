import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_data_provider.dart';
import '../utils/responsive.dart';

class StageButton extends StatefulWidget {
  final String label;
  final Color color;
  final int sectionIndex;
  final int stageIndex;
  final VoidCallback onPressed;

  const StageButton({
    super.key,
    required this.label,
    required this.color,
    required this.sectionIndex,
    required this.stageIndex,
    required this.onPressed,
  });

  @override
  State<StageButton> createState() => _StageButtonState();
}

class _StageButtonState extends State<StageButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.92);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.onPressed.call();
  }

  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig.hp(SizeConfig.isLandscape(context) ? 20 : 11);

    return Consumer<StudyDataProvider>(
      builder: (context, provider, child) {
        final sectionIndex = widget.sectionIndex;
        final stageIndex = widget.stageIndex;
        final section = provider.sections[sectionIndex];
        final stage = section.stages[stageIndex];

        final Color base = stage.isEnabled ? widget.color : Colors.grey;

        return GestureDetector(
          onTapDown: stage.isEnabled ? _onTapDown : null,
          onTapUp: stage.isEnabled ? _onTapUp : null,
          onTapCancel: stage.isEnabled ? _onTapCancel : null,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // BACK "shadow rim"
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          base
                            ..withAlpha(
                              (0.4 * 255).toInt(),
                            ),
                          base
                            ..withAlpha(
                              (0.9 * 255).toInt(),
                            ),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          offset: Offset(4, 6),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),

                  // GLOSS + bevel
                  Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white
                            ..withAlpha(
                              (0.5 * 255).toInt(),
                            ),
                          base
                            ..withAlpha(
                              (0.8 * 255).toInt(),
                            ),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white
                            ..withAlpha(
                              (0.6 * 255).toInt(),
                            ),
                          offset: const Offset(-2, -2),
                          blurRadius: 6,
                          spreadRadius: -2,
                        ),
                        BoxShadow(
                          color: base
                            ..withAlpha(
                              (0.5 * 255).toInt(),
                            ),
                          offset: const Offset(3, 3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),

                  // LABEL
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // FULL OUTLINE STAR
                  if (stage.isCompleted)
                    Positioned.fill(
                      child: Icon(
                        Icons.star_border,
                        size: size,
                        color: Colors.amber
                          ..withAlpha(
                            (0.8 * 255).toInt(),
                          ),
                        shadows: [
                          Shadow(
                            color: Colors.amber
                              ..withAlpha(
                                (0.6 * 255).toInt(),
                              ),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
