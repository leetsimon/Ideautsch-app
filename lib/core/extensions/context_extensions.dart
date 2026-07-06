import 'package:flutter/material.dart';

/// Extension methods on [BuildContext] for convenient access
/// to commonly used theme and media query properties.
extension ContextExtensions on BuildContext {
  /// Current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Current [ColorScheme].
  ColorScheme get colorScheme => theme.colorScheme;

  /// Current [TextTheme].
  TextTheme get textTheme => theme.textTheme;

  /// Current [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen width in logical pixels.
  double get screenWidth => mediaQuery.size.width;

  /// Screen height in logical pixels.
  double get screenHeight => mediaQuery.size.height;

  /// Whether the device is in landscape orientation.
  bool get isLandscape =>
      mediaQuery.orientation == Orientation.landscape;

  /// Whether the screen width suggests a tablet/desktop layout.
  bool get isWideScreen => screenWidth >= 600;

  /// Whether dark mode is active.
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Bottom padding to account for system navigation.
  double get bottomPadding => mediaQuery.padding.bottom;

  /// Top padding to account for status bar.
  double get topPadding => mediaQuery.padding.top;
}
