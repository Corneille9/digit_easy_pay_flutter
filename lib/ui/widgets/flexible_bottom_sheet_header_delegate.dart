import 'package:flutter/widgets.dart';

/// Delegate for configuring a [SliverPersistentHeader].
class FlexibleBottomSheetHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  FlexibleBottomSheetHeaderDelegate({
    required this.maxHeight,
    required this.child,
    this.minHeight = 0,
  });

  @override
  bool shouldRebuild(FlexibleBottomSheetHeaderDelegate oldDelegate) => true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }
}
