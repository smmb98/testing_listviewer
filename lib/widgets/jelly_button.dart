import 'package:flutter/material.dart';
import 'package:testing_listviewer/utils/responsive.dart';
import 'package:provider/provider.dart';
import '../providers/button_state_provider.dart';

class JellyButton extends StatelessWidget {
  final String label;
  final Color color;
  final int sectionIndex;
  final int buttonIndex;
  final VoidCallback? onPressed;

  const JellyButton({
    super.key,
    required this.label,
    required this.color,
    required this.sectionIndex,
    required this.buttonIndex,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ButtonStateProvider>(
      builder: (context, buttonStateProvider, child) {
        final isEnabled =
            buttonStateProvider.isButtonEnabled(sectionIndex, buttonIndex);
        final isCompleted =
            buttonStateProvider.isButtonCompleted(sectionIndex, buttonIndex);

        return GestureDetector(
          onTap: isEnabled ? onPressed : null,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.yellow, width: 1),
            ),
            child: Container(
              width: SizeConfig.hp(SizeConfig.isLandscape(context) ? 20 : 11),
              height: SizeConfig.hp(SizeConfig.isLandscape(context) ? 20 : 11),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    isEnabled
                        ? color.withAlpha((0.9 * 255).toInt())
                        : Colors.grey.withAlpha((0.9 * 255).toInt()),
                    isEnabled
                        ? color.withAlpha((0.6 * 255).toInt())
                        : Colors.grey.withAlpha((0.6 * 255).toInt()),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isEnabled
                        ? color.withAlpha((0.6 * 255).toInt())
                        : Colors.grey.withAlpha((0.6 * 255).toInt()),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  if (isCompleted)
                    const Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
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
