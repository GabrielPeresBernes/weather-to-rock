import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_to_rock/app/components/dismiss_keyboard.dart';
import 'package:weather_to_rock/app/theme/theme.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.routerConfig,
  });

  final RouterConfig<Object> routerConfig;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp.router(
      routerConfig: routerConfig,
      theme: AppTheme.theme,
      builder: (_, child) => DismissKeyboard(
        child: Center(child: child),
      ),
    );
  }
}
