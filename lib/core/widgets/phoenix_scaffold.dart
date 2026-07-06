import 'package:flutter/material.dart';

import '../theme/spacing.dart';

/// Base scaffold widget used across all screens.
///
/// Provides consistent page structure with:
/// - Standard padding
/// - Optional app bar title
/// - Optional floating action button
/// - Safe area handling
///
/// All pages use this instead of raw [Scaffold] to ensure
/// visual consistency.
class PhoenixScaffold extends StatelessWidget {
  const PhoenixScaffold({
    required this.body,
    super.key,
    this.title,
    this.floatingActionButton,
    this.showBackButton = false,
    this.actions,
    this.bottomNavigationBar,
    this.padding,
  });

  /// The main content of the screen.
  final Widget body;

  /// Optional app bar title. If null, no app bar is shown.
  final String? title;

  /// Optional FAB (used for microphone button in exercise screens).
  final Widget? floatingActionButton;

  /// Whether to show a back button in the app bar.
  final bool showBackButton;

  /// Optional app bar actions.
  final List<Widget>? actions;

  /// Optional bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Custom padding for the body. Defaults to standard page padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              automaticallyImplyLeading: showBackButton,
              actions: actions,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: Spacing.pagePaddingHorizontal,
                vertical: Spacing.pagePaddingVertical,
              ),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
