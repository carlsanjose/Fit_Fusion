import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'screens/welcome/welcome_screen.dart';
import 'shell.dart';

class WorkoutShufflerApp extends StatelessWidget {
  const WorkoutShufflerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Shuffler',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const _SplashGate(),
        '/welcome': (_) => const WelcomeScreen(),
        '/home': (_) => const AppShell(),
      },
    );
  }
}

// Decides whether to show welcome or go straight to home
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
      backgroundColor: Color(0xFF0A0A0A),
      body: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFFE8FF47),
          ),
        ),
      ),
    );
  }
}
