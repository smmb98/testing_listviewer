import 'package:flutter/material.dart';
import '../models/section_model.dart';
import '../utils/responsive.dart';

class SectionHeader extends StatelessWidget {
  final SectionModel section;
  final bool isLandscape;

  const SectionHeader({
    super.key,
    required this.section,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: section.color,
        border: Border.all(color: Colors.green, width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        section.title,
        style: TextStyle(
          color: Colors.white,
          fontSize: SizeConfig.sp(5.3),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
