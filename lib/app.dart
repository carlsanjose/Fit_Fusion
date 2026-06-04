import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_colors.dart';
import 'screens/welcome/welcome_screen.dart';
import 'shell.dart';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);
final unitNotifier = ValueNotifier<WeightUnit>(WeightUnit.kg);

enum WeightUnit { kg, lbs }

double toDisplayWeight(double kg, WeightUnit unit) =>
    unit == WeightUnit.kg ? kg : kg * 2.20462;

String formatWeight(double kg, WeightUnit unit) {
  final val = toDisplayWeight(kg, unit);
  final display = val % 1 == 0
      ? val.toInt().toString()
      : val.toStringAsFixed(1);
  return '$display ${unit == WeightUnit.kg ? 'kg' : 'lbs'}';
}

String unitLabel(WeightUnit unit) => unit == WeightUnit.kg ? 'KG' : 'LBS';

Future<void> loadSavedTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('theme_mode');
  if (saved == 'light') themeNotifier.value = ThemeMode.light;
  final savedUnit = prefs.getString('weight_unit');
  if (savedUnit == 'lbs') unitNotifier.value = WeightUnit.lbs;
}

Future<void> saveTheme(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    'theme_mode',
    mode == ThemeMode.light ? 'light' : 'dark',
  );
}

Future<void> saveUnit(WeightUnit unit) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('weight_unit', unit == WeightUnit.kg ? 'kg' : 'lbs');
}

void toggleTheme() {
  final next = themeNotifier.value == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;
  themeNotifier.value = next;
  saveTheme(next);
}

void toggleUnit() {
  final next = unitNotifier.value == WeightUnit.kg
      ? WeightUnit.lbs
      : WeightUnit.kg;
  unitNotifier.value = next;
  saveUnit(next);
}

class WorkoutShufflerApp extends StatelessWidget {
  const WorkoutShufflerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Workout Shuffler',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          initialRoute: '/splash',
          routes: {
            '/splash': (_) => const _SplashGate(),
            '/welcome': (_) => const WelcomeScreen(),
            '/home': (_) => const AppShell(),
          },
        );
      },
    );
  }
}

class _SplashGate extends StatefulWidget {
  const _SplashGate();

  @override
  State<_SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<_SplashGate> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seen_welcome') ?? false;
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(seen ? '/home' : '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: kLime),
        ),
      ),
    );
  }
}
