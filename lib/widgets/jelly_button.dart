import 'package:flutter/material.dart';
import 'package:testing_listviewer/utils/responsive.dart';

class JellyButton extends StatelessWidget {
  final String label;
  final Color color;

  const JellyButton({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow, width: 1),
      ),
      child: Container(
        width: SizeConfig.hp(SizeConfig.isLandscape(context) ? 20 : 11),
        height: SizeConfig.hp(SizeConfig.isLandscape(context) ? 20 : 11),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
