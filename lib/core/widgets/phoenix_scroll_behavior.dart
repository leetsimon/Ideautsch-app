import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Custom scroll behavior for premium scrolling feel.
///
/// - On Android: Uses default Material overscroll (stretch)
/// - On Windows: Uses smooth scroll with mouse wheel optimization
/// - Removes scroll glow on Windows (desktop doesn't use it)
/// - Enables smooth scrolling for all platforms
class PhoenixScrollBehavior extends MaterialScrollBehavior {
  const PhoenixScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
        // Desktop: smooth, no overscroll bounce
        return const ClampingScrollPhysics(
          parent: RangeMaintainingScrollPhysics(),
        );
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        // Mobile: Material stretch overscroll
        return const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        );
    }
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
        // No overscroll indicator on desktop
        return child;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        // Material 3 stretch overscroll on mobile
        return StretchingOverscrollIndicator(
          axisDirection: details.direction,
          child: child,
        );
    }
  }
}
