import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps content to handle keyboard shortcuts and focus management.
///
/// On Windows, enables:
/// - Escape to go back / dismiss overlays
/// - Enter/Space to activate focused buttons
/// - Tab to navigate between interactive elements
/// - Arrow keys for option selection
///
/// On all platforms:
/// - Tapping outside text fields dismisses keyboard
/// - Focus indicators visible for keyboard navigation
class KeyboardDismissible extends StatelessWidget {
  const KeyboardDismissible({
    required this.child,
    super.key,
    this.onEscape,
  });

  final Widget child;
  final VoidCallback? onEscape;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          if (onEscape != null) {
            onEscape!();
          } else {
            Navigator.of(context).maybePop();
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: child,
      ),
    );
  }
}

/// A focus-aware wrapper that shows visible focus rings on Windows.
///
/// Material 3 provides focus indicators by default, but this ensures
/// consistent 2px primary-color focus rings on all custom widgets.
class FocusableWidget extends StatefulWidget {
  const FocusableWidget({
    required this.child,
    required this.onActivate,
    super.key,
    this.borderRadius = 12,
  });

  final Widget child;
  final VoidCallback onActivate;
  final double borderRadius;

  @override
  State<FocusableWidget> createState() => _FocusableWidgetState();
}

class _FocusableWidgetState extends State<FocusableWidget> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          widget.onActivate();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: _isFocused
              ? Border.all(color: colorScheme.primary, width: 2)
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
