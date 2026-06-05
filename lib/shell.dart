import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';
import 'core/theme/app_theme.dart';
import 'models/exercise.dart';
import 'models/active_exercise.dart';
import 'services/storage_service.dart';
import 'services/timer_service.dart';
import 'screens/home/home_screen.dart';
import 'screens/database/database_screen.dart';
import 'screens/session/session_screen.dart';
import 'widgets/rest_timer_sheet.dart';
import 'core/utils/responsive.dart';
import 'models/workout_day.dart';
import 'models/workout_log.dart';
import 'screens/session/day_picker_sheet.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  List<Exercise> savedExercises = [];
  List<ActiveExercise> currentSession = [];

  List<WorkoutDay> workoutDays = [];
  List<WorkoutLog> workoutLogs = [];

  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  final _storage = StorageService();
  final _timer = TimerService();

  bool _timerVisible = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _timer.addListener(_onTimerUpdate);
    themeNotifier.addListener(_onThemeChange);
  }

  void _onThemeChange() => setState(() {});

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    for (final a in currentSession) {
      a.weightController.dispose();
    }
    _timer.removeListener(_onTimerUpdate);
    themeNotifier.removeListener(_onThemeChange);
    _timer.dispose();
    super.dispose();
  }

  void _onTimerUpdate() {
    if (_timer.isFinished) {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _timer.isFinished) {
          setState(() => _timerVisible = false);
          _timer.reset();
        }
      });
    }
  }

  void _showTimerSheet() {
    setState(() => _timerVisible = true);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      builder: (_) => RestTimerSheet(
        timerService: _timer,
        onDismiss: () {
          setState(() => _timerVisible = false);
          Navigator.pop(context);
        },
      ),
    ).then((_) => setState(() => _timerVisible = false));
  }

  // ─── Data ──────────────────────────────────────────────────────────────────

  Future<void> _loadData() async {
    final exercises = await _storage.loadExercises();
    final session = await _storage.loadSession();
    final days = await _storage.loadWorkoutDays();
    final logs = await _storage.loadWorkoutLog();

    setState(() {
      savedExercises = exercises;
      currentSession = session;
      workoutDays = days;
      workoutLogs = logs;
    });
  }

  void _updateWorkoutDays(List<WorkoutDay> days) {
    setState(() => workoutDays = days);
    _storage.saveWorkoutDays(days);
  }

  void _logWorkout(String dayName) async {
    final done = currentSession.where((e) => e.isDone).length;
    final total = currentSession.length;
    if (total == 0) return;
    final log = WorkoutLog(
      date: DateTime.now(),
      dayName: dayName,
      exerciseCount: total,
      completedCount: done,
    );
    await _storage.appendWorkoutLog(log);
    final logs = await _storage.loadWorkoutLog();
    setState(() => workoutLogs = logs);
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
          muscleGroup: '',
          notes: '',
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
    final cs = Theme.of(context).colorScheme;
    final exercise = savedExercises[index];
    final controller = TextEditingController(text: exercise.weight.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text(
          'Edit ${exercise.name}',
          style: TextStyle(color: cs.textPri),
        ),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          style: TextStyle(color: cs.textPri),
          decoration: const InputDecoration(labelText: 'Weight (KG)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: cs.textSec)),
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
            child: Text('Save', style: TextStyle(color: cs.lime)),
          ),
        ],
      ),
    );
  }

  void _loadTemplate(List<Exercise> exercises, List<WorkoutDay> days) {
    final cs = Theme.of(context).colorScheme;
    setState(() {
      savedExercises = List.from(exercises);
      workoutDays = List.from(days);
    });
    _storage.saveExercises(savedExercises);
    _storage.saveWorkoutDays(workoutDays);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${exercises.length} exercises and ${days.length} day(s) loaded',
          style: const TextStyle(color: Color(0xFF0A0A0A)),
        ),
        backgroundColor: cs.lime,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDayPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DayPickerSheet(
        workoutDays: workoutDays,
        allExercises: savedExercises,
        onShuffleAll: () {
          _shuffleFromExercises(savedExercises, 'Full Shuffle');
          setState(() => _selectedIndex = 2);
        },
        onDaySelected: (day) {
          final dayExercises = day.exerciseNames
              .map(
                (name) =>
                    savedExercises.where((e) => e.name == name).firstOrNull,
              )
              .whereType<Exercise>()
              .toList();
          _shuffleFromExercises(dayExercises, day.name);
          setState(() => _selectedIndex = 2);
        },
      ),
    );
  }

  String _currentDayName = 'Workout';

  void _shuffleFromExercises(List<Exercise> exercises, String dayName) {
    if (exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No exercises for this day!')),
      );
      return;
    }
    setState(() {
      for (final a in currentSession) {
        a.weightController.dispose();
      }
      currentSession =
          exercises.map((e) => ActiveExercise(exercise: e)).toList()..shuffle();
      _currentDayName = dayName;
    });
    _storage.saveSession(currentSession);
  }

  void _toggleDone(int index) {
    setState(
      () => currentSession[index].isDone = !currentSession[index].isDone,
    );
    _storage.saveSession(currentSession);

    if (currentSession[index].isDone) {
      _timer.start(90);
      _showTimerSheet();

      // Auto-log when all done
      final allDone = currentSession.every((e) => e.isDone);
      if (allDone) _logWorkout(_currentDayName);
    }
  }

  void _shuffleRoutine() {
    if (savedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add some exercises first!')),
      );
      return;
    }
    _showDayPicker();
  }

  void _onWeightChanged() => _storage.saveSession(currentSession);

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final done = currentSession.where((e) => e.isDone).length;
    final cs = Theme.of(context).colorScheme;

    final screens = [
      HomeScreen(
        exerciseCount: savedExercises.length,
        sessionCount: currentSession.length,
        doneCount: done,
        workoutLogs: workoutLogs, // new
        onShuffle: () {
          _shuffleRoutine();
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
        onLoadTemplate: _loadTemplate,
        workoutDays: workoutDays, // new
        onDaysChanged: _updateWorkoutDays, // new
      ),
      SessionScreen(
        session: currentSession,
        onShuffle: _shuffleRoutine,
        onToggleDone: _toggleDone,
        onWeightChanged: _onWeightChanged,
        onStartTimer: (seconds) {
          _timer.start(seconds);
          _showTimerSheet();
        },
      ),
    ];

    return Scaffold(
      backgroundColor: cs.bg,
      body: Stack(
        children: [
          IndexedStack(index: _selectedIndex, children: screens),

          // Floating timer pill
          if (_timer.isRunning && !_timerVisible)
            Positioned(
              bottom: 90,
              left: 24,
              right: 24,
              child: GestureDetector(
                onTap: _showTimerSheet,
                child: AnimatedBuilder(
                  animation: _timer,
                  builder: (_, _) {
                    final cs = Theme.of(context).colorScheme;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: cs.lime, width: 1),
                        boxShadow: cs.brightness == Brightness.light
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.timer_rounded, color: cs.lime, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'REST — ${_timer.display}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 14,
                              color: cs.lime,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'TAP TO MANAGE',
                            style: GoogleFonts.rajdhani(
                              fontSize: 10,
                              color: cs.textMuted,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;

    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.storage_rounded, 'Library'),
      (Icons.fitness_center_rounded, 'Session'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          top: BorderSide(
            color: cs.brightness == Brightness.dark ? cs.border : cs.border2,
            width: 0.5,
          ),
        ),
        boxShadow: cs.brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
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
                        // use cs.lime for active so it switches per mode
                        color: active
                            ? cs.lime
                            : cs.brightness == Brightness.dark
                            ? cs.textMuted
                            : cs.textSec,
                        size: r.sp(22),
                      ),
                      SizedBox(height: r.xs / 2),
                      Text(
                        items[i].$2,
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(10),
                          color: active
                              ? cs.lime
                              : cs.brightness == Brightness.dark
                              ? cs.textMuted
                              : cs.textSec,
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
                          color: cs.lime,
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
