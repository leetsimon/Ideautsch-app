import 'package:flutter/material.dart';

/// Shared-axis page transition (horizontal).
///
/// Used for forward/backward navigation between screens.
/// Follows Material 3 motion guidelines for container transforms.
class SharedAxisPageTransition extends StatelessWidget {
  const SharedAxisPageTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
    super.key,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0.8).animate(
            CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeIn,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Custom route that applies shared-axis transition.
class PhoenixPageRoute<T> extends PageRouteBuilder<T> {
  PhoenixPageRoute({
    required this.page,
    super.settings,
  }) : super(
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            return SharedAxisPageTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
        );

  final Widget page;
}

/// Fade-through transition for switching between tabs/sections.
class FadeThroughTransition extends StatelessWidget {
  const FadeThroughTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
    super.key,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: child,
      ),
    );
  }
}
