import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'models/exercise.dart';
import 'models/active_exercise.dart';
import 'services/storage_service.dart';
import 'screens/home/home_screen.dart';
import 'screens/database/database_screen.dart';
import 'screens/session/session_screen.dart';
import 'core/utils/responsive.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  List<Exercise> savedExercises = [];
  List<ActiveExercise> currentSession = [];

  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  final _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    for (final a in currentSession) {
      a.weightController.dispose();
    }
    super.dispose();
  }

  Future<void> _loadData() async {
    final exercises = await _storage.loadExercises();
    final session = await _storage.loadSession();
    setState(() {
      savedExercises = exercises;
      currentSession = session;
    });
  }

  void _addExercise() {
    if (_nameController.text.isEmpty ||
        _setsController.text.isEmpty ||
        _repsController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    setState(() {
      savedExercises.add(
        Exercise(
          name: _nameController.text.trim(),
          sets: int.tryParse(_setsController.text.trim()) ?? 0,
          reps: int.tryParse(_repsController.text.trim()) ?? 0,
          weight: double.tryParse(_weightController.text.trim()) ?? 0.0,
        ),
      );
      _nameController.clear();
      _setsController.clear();
      _repsController.clear();
      _weightController.clear();
    });
    _storage.saveExercises(savedExercises);
  }

  void _deleteExercise(int index) {
    setState(() => savedExercises.removeAt(index));
    _storage.saveExercises(savedExercises);
  }

  void _editDatabaseWeight(int index) {
    final exercise = savedExercises[index];
    final controller = TextEditingController(text: exercise.weight.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kSurface,
        title: Text(
          'Edit ${exercise.name}',
          style: const TextStyle(color: kTextPri),
        ),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          style: const TextStyle(color: kTextPri),
          decoration: const InputDecoration(labelText: 'Weight (KG)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: kTextSec)),
          ),
          TextButton(
            onPressed: () {
              final parsed = double.tryParse(controller.text);
              if (parsed != null) {
                setState(() => exercise.weight = parsed);
                _storage.saveExercises(savedExercises);
                Navigator.pop(context);
              }
            },
            child: const Text('Save', style: TextStyle(color: kLime)),
          ),
        ],
      ),
    );
  }

  void _shuffleRoutine() {
    if (savedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add some exercises first!')),
      );
      return;
    }
    setState(() {
      for (final a in currentSession) {
        a.weightController.dispose();
      }
      currentSession =
          savedExercises.map((e) => ActiveExercise(exercise: e)).toList()
            ..shuffle();
    });
    _storage.saveSession(currentSession);
  }

  void _toggleDone(int index) {
    setState(
      () => currentSession[index].isDone = !currentSession[index].isDone,
    );
    _storage.saveSession(currentSession);
  }

  void _onWeightChanged() {
    _storage.saveSession(currentSession);
  }

  @override
  Widget build(BuildContext context) {
    final done = currentSession.where((e) => e.isDone).length;

    final screens = [
      HomeScreen(
        exerciseCount: savedExercises.length,
        sessionCount: currentSession.length,
        doneCount: done,
        onShuffle: () {
          _shuffleRoutine();
          setState(() => _selectedIndex = 2);
        },
      ),
      DatabaseScreen(
        exercises: savedExercises,
        nameController: _nameController,
        setsController: _setsController,
        repsController: _repsController,
        weightController: _weightController,
        onAdd: _addExercise,
        onDelete: _deleteExercise,
        onEdit: _editDatabaseWeight,
      ),
      SessionScreen(
        session: currentSession,
        onShuffle: _shuffleRoutine,
        onToggleDone: _toggleDone,
        onWeightChanged: _onWeightChanged,
      ),
    ];

    return Scaffold(
      backgroundColor: kBg,
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final r = Responsive(context);
    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.storage_rounded, 'Library'),
      (Icons.fitness_center_rounded, 'Session'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: kSurface,
        border: Border(top: BorderSide(color: kBorder, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.lg, vertical: r.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final active = _selectedIndex == i;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedIndex = i);
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.md,
                    vertical: r.xs,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[i].$1,
                        color: active ? kLime : kTextMuted,
                        size: r.sp(22),
                      ),
                      SizedBox(height: r.xs / 2),
                      Text(
                        items[i].$2,
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(10),
                          color: active ? kLime : kTextMuted,
                          letterSpacing: 1,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: r.xs / 2),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: active ? r.sp(18) : 0,
                        height: 2,
                        decoration: BoxDecoration(
                          color: kLime,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
