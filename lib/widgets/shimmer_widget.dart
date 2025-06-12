import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSectionWidget extends StatelessWidget {
  final int sectionIndex;

  const ShimmerSectionWidget({super.key, required this.sectionIndex});

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [];
    final offsets = [0.0, 20.0, 30.0, 20.0, 0.0, -20.0, -30.0, -20.0];
    final reverseOffsets = offsets.map((offset) => -offset).toList();
    final adjustedOffsets = (sectionIndex % 2 == 1) ? reverseOffsets : offsets;

    for (int i = 0; i < 8; i++) {
      double offset = (i == 0 || i == 7)
          ? 0
          : adjustedOffsets[i % adjustedOffsets.length];
      buttons.add(
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Align(
              alignment: Alignment(offset / 100, 0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(
                  width: 200,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...buttons,
          ],
        ),
      ),
    );
  }
}
