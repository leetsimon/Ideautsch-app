import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/settings/settings_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/phoenix_scroll_behavior.dart';

/// The root widget of Project Phoenix.
///
/// Configures Material 3 theming (light + dark), navigation via GoRouter,
/// BLoC providers for app-level state, custom scroll behavior,
/// and provides the application shell.
class PhoenixApp extends StatelessWidget {
  const PhoenixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'Project Phoenix',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: settings.themeMode,
            routerConfig: appRouter,
            scrollBehavior: const PhoenixScrollBehavior(),
          );
        },
      ),
    );
  }
}
