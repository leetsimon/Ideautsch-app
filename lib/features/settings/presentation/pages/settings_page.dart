import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/settings/settings_cubit.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/phoenix_scaffold.dart';

/// Settings page — clean, professional preferences management.
///
/// Sections:
/// - Appearance (theme mode)
/// - Learning (daily goal, audio speed)
/// - Language Support (Darija, French toggles)
/// - About
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PhoenixScaffold(
      title: 'Settings',
      showBackButton: true,
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // Appearance
              _SectionHeader(title: 'Appearance'),
              _buildThemeSelector(context, settings),
              const SizedBox(height: Spacing.xxl),

              // Learning
              _SectionHeader(title: 'Learning'),
              _buildDailyGoal(context, settings),
              _buildAudioSpeed(context, settings),
              const SizedBox(height: Spacing.xxl),

              // Language Support
              _SectionHeader(title: 'Language Support'),
              _buildToggle(
                context,
                title: 'Darija Translations',
                subtitle: 'Show Moroccan Arabic explanations',
                value: settings.showDarijaTranslations,
                onChanged: (value) {
                  context.read<SettingsCubit>().toggleDarijaTranslations(
                        show: value,
                      );
                },
              ),
              _buildToggle(
                context,
                title: 'French Bridges',
                subtitle: 'Show French pronunciation bridges',
                value: settings.showFrenchBridges,
                onChanged: (value) {
                  context
                      .read<SettingsCubit>()
                      .toggleFrenchBridges(show: value);
                },
              ),
              const SizedBox(height: Spacing.xxl),

              // About
              _SectionHeader(title: 'About'),
              _buildAboutTile(
                context,
                title: 'Version',
                trailing: '0.1.0',
              ),
              _buildAboutTile(
                context,
                title: 'Works Offline',
                trailing: '100%',
              ),
              const SizedBox(height: Spacing.huge),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, SettingsState settings) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.pagePaddingHorizontal),
      child: Row(
        children: [
          _ThemeOption(
            icon: Icons.brightness_auto_rounded,
            label: 'System',
            selected: settings.themeMode == ThemeMode.system,
            onTap: () => context.read<SettingsCubit>().setThemeMode(ThemeMode.system),
          ),
          const SizedBox(width: Spacing.sm),
          _ThemeOption(
            icon: Icons.light_mode_rounded,
            label: 'Light',
            selected: settings.themeMode == ThemeMode.light,
            onTap: () => context.read<SettingsCubit>().setThemeMode(ThemeMode.light),
          ),
          const SizedBox(width: Spacing.sm),
          _ThemeOption(
            icon: Icons.dark_mode_rounded,
            label: 'Dark',
            selected: settings.themeMode == ThemeMode.dark,
            onTap: () => context.read<SettingsCubit>().setThemeMode(ThemeMode.dark),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoal(BuildContext context, SettingsState settings) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.pagePaddingHorizontal,
      ),
      title: Text('Daily Goal', style: textTheme.bodyLarge),
      subtitle: Text(
        '${settings.dailyGoalMinutes} minutes per day',
        style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      trailing: DropdownButton<int>(
        value: settings.dailyGoalMinutes,
        underline: const SizedBox(),
        items: [10, 15, 20, 25, 30, 45]
            .map((m) => DropdownMenuItem(value: m, child: Text('$m min')))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<SettingsCubit>().setDailyGoal(value);
          }
        },
      ),
    );
  }

  Widget _buildAudioSpeed(BuildContext context, SettingsState settings) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.pagePaddingHorizontal,
      ),
      title: Text('Default Audio Speed', style: textTheme.bodyLarge),
      subtitle: Text(
        '${settings.audioPlaybackSpeed}x',
        style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      trailing: DropdownButton<double>(
        value: settings.audioPlaybackSpeed,
        underline: const SizedBox(),
        items: [0.7, 0.85, 1.0, 1.15]
            .map((s) => DropdownMenuItem(value: s, child: Text('${s}x')))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<SettingsCubit>().setAudioSpeed(value);
          }
        },
      ),
    );
  }

  Widget _buildToggle(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.pagePaddingHorizontal,
      ),
      title: Text(title, style: textTheme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildAboutTile(
    BuildContext context, {
    required String title,
    required String trailing,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.pagePaddingHorizontal,
      ),
      title: Text(title, style: textTheme.bodyLarge),
      trailing: Text(
        trailing,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.pagePaddingHorizontal,
        Spacing.lg,
        Spacing.pagePaddingHorizontal,
        Spacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: Spacing.md),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer.withOpacity(0.5)
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(Spacing.cardRadius),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
