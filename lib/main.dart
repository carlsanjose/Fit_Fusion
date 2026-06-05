import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await loadSavedTheme();
  _setSystemOverlayStyle();
  themeNotifier.addListener(_setSystemOverlayStyle);
  runApp(const WorkoutShufflerApp());
}

void _setSystemOverlayStyle() {
  final isDark = themeNotifier.value != ThemeMode.light;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
    ),
  );
}
