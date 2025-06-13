import 'package:flutter/material.dart';

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  final VoidCallback? onPinned;
  final VoidCallback? onUnpinned;
  final int sectionIndex;

  SectionHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
    required this.sectionIndex,
    this.onPinned,
    this.onUnpinned,
  });

  bool _wasPinned = false; // Local state per build

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isPinned = shrinkOffset > 0;

    if (isPinned && !_wasPinned) {
      _wasPinned = true;
      onPinned?.call();
    } else if (!isPinned && _wasPinned) {
      _wasPinned = false;
      onUnpinned?.call();
    }

    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SectionHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
