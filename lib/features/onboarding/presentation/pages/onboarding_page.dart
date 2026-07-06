import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/phoenix_button.dart';
import '../../../../core/widgets/yasmina_avatar.dart';

/// First-time onboarding flow.
///
/// Three pages:
/// 1. Welcome (Yasmina introduces herself)
/// 2. Goal setting (time commitment)
/// 3. Ready (transition to first mission)
///
/// No account creation. No email. No quiz.
/// Just: recognize the learner, set expectations, begin.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.pagePaddingHorizontal,
                vertical: Spacing.lg,
              ),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomePage(context),
                  _buildGoalPage(context),
                  _buildReadyPage(context),
                ],
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(Spacing.pagePaddingHorizontal),
              child: PhoenixButton(
                label: _currentPage == 2 ? 'Start Learning' : 'Continue',
                icon: _currentPage == 2
                    ? Icons.rocket_launch_rounded
                    : Icons.arrow_forward_rounded,
                isExpanded: true,
                onPressed: _nextPage,
              ),
            ),
            const SizedBox(height: Spacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(Spacing.pagePaddingHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const YasminaAvatar(
            size: 80,
            expression: YasminaExpression.welcoming,
            isSpeaking: true,
          ),
          const SizedBox(height: Spacing.xxl),
          Text(
            'مرحبا بيك',
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
          const SizedBox(height: Spacing.md),
          Text(
            'I\'m Yasmina. I made this journey — Casablanca to '
            'Düsseldorf, zero German to Team Lead. I\'m going to '
            'help you do the same.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 500.ms).fadeIn(duration: 500.ms),
          const SizedBox(height: Spacing.xxl),
          Container(
            padding: const EdgeInsets.all(Spacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
            ),
            child: Text(
              'This app teaches you German for ONE goal: getting a job '
              'in customer service. No textbook grammar. No tourist phrases. '
              'Professional German that gets you hired.',
              style: textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ).animate(delay: 800.ms).fadeIn(duration: 500.ms),
        ],
      ),
    );
  }

  Widget _buildGoalPage(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(Spacing.pagePaddingHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_rounded,
            size: 56,
            color: colorScheme.primary,
          ),
          const SizedBox(height: Spacing.xxl),
          Text(
            'How much time can you practice daily?',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.xxxl),
          _GoalOption(
            label: '10 minutes',
            subtitle: 'Light maintenance',
            selected: false,
            onTap: () {},
          ),
          const SizedBox(height: Spacing.md),
          _GoalOption(
            label: '25 minutes',
            subtitle: 'Recommended — optimal learning',
            selected: true,
            onTap: () {},
          ),
          const SizedBox(height: Spacing.md),
          _GoalOption(
            label: '45 minutes',
            subtitle: 'Intensive — fastest progress',
            selected: false,
            onTap: () {},
          ),
          const SizedBox(height: Spacing.xxl),
          Text(
            'You can change this anytime. No pressure.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyPage(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(Spacing.pagePaddingHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 72,
            color: colorScheme.primary,
          ).animate().scale(
                begin: const Offset(0.5, 0.5),
                duration: 600.ms,
                curve: Curves.easeOutBack,
              ),
          const SizedBox(height: Spacing.xxl),
          Text(
            'You\'re ready.',
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            'In the next 10 minutes, you will speak your first '
            'professional German sentence. A complete phone greeting '
            'used in every call center in Germany.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.xxxl),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
              vertical: Spacing.md,
            ),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(Spacing.chipRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 16,
                  color: colorScheme.tertiary,
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  'Works 100% offline',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  const _GoalOption({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primaryContainer.withOpacity(0.4)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(
            color: selected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
