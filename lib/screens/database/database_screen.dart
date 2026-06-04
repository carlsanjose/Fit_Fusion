import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../data/starter_templates.dart';
import '../../models/exercise.dart';
import '../../widgets/exercise_card.dart';
import '../../widgets/muscle_badge.dart';
import '../../models/workout_day.dart';
import '../database/workout_days.dart';
import '../../app.dart';

class DatabaseScreen extends StatefulWidget {
  final List<Exercise> exercises;
  final TextEditingController nameController;
  final TextEditingController setsController;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final VoidCallback onAdd;
  final void Function(int index) onDelete;
  final void Function(int index) onEdit;
  final void Function(List<Exercise> exercises, List<WorkoutDay> days)
  onLoadTemplate;
  final List<WorkoutDay> workoutDays;
  final void Function(List<WorkoutDay>) onDaysChanged;

  const DatabaseScreen({
    super.key,
    required this.exercises,
    required this.nameController,
    required this.setsController,
    required this.repsController,
    required this.weightController,
    required this.onAdd,
    required this.onDelete,
    required this.onEdit,
    required this.onLoadTemplate,
    required this.workoutDays,
    required this.onDaysChanged,
  });

  @override
  State<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  final _workoutDaysKey = GlobalKey<WorkoutDaysScreenState>();

  void _showAddSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _AddExerciseSheet(
          nameController: widget.nameController,
          setsController: widget.setsController,
          repsController: widget.repsController,
          weightController: widget.weightController,
          onAdd: () {
            widget.onAdd();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showTemplatesSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _TemplatesSheet(
        onLoad: (template) {
          widget.onLoadTemplate(template.exercises, template.workoutDays);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;

    const double fabClearance = 88.0;

    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: cs.bg,
            floatingActionButton: FloatingActionButton(
              backgroundColor: cs.lime,
              foregroundColor: cs.onPrimary,
              elevation: 0,
              onPressed: () {
                final tabIndex = DefaultTabController.of(context).index;
                if (tabIndex == 0) {
                  _showAddSheet(context);
                } else {
                  _workoutDaysKey.currentState?.addDay();
                }
              },
              child: Icon(Icons.add_rounded, size: r.sp(24)),
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(r.lg, r.lg, r.lg, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LIBRARY',
                          style: GoogleFonts.rajdhani(
                            fontSize: r.sp(11),
                            color: cs.lime,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: r.xs / 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'EXERCISES',
                                style: GoogleFonts.rajdhani(
                                  fontSize: r.sp(36),
                                  fontWeight: FontWeight.w700,
                                  color: cs.textPri,
                                  height: 1,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            ValueListenableBuilder<WeightUnit>(
                              valueListenable: unitNotifier,
                              builder: (context, unit, _) {
                                return GestureDetector(
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    toggleUnit();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: r.sm,
                                      vertical: r.xs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cs.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: cs.border2,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'KG',
                                          style: GoogleFonts.rajdhani(
                                            fontSize: r.sp(13),
                                            color: unit == WeightUnit.kg
                                                ? cs.lime
                                                : cs.textMuted,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        SizedBox(width: r.xs),
                                        SizedBox(
                                          height: r.sp(20),
                                          child: VerticalDivider(
                                            color: cs.border2,
                                            width: 1,
                                            thickness: 0.5,
                                          ),
                                        ),
                                        SizedBox(width: r.xs),
                                        Text(
                                          'LBS',
                                          style: GoogleFonts.rajdhani(
                                            fontSize: r.sp(13),
                                            color: unit == WeightUnit.lbs
                                                ? cs.lime
                                                : cs.textMuted,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: r.md),
                        TabBar(
                          labelColor: cs.lime,
                          unselectedLabelColor: cs.textMuted,
                          indicatorColor: cs.lime,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 2,
                          dividerColor: cs.border,
                          labelStyle: GoogleFonts.rajdhani(
                            fontSize: r.sp(13),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                          tabs: const [
                            Tab(text: 'EXERCISES'),
                            Tab(text: 'DAYS'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        widget.exercises.isEmpty
                            ? _buildEmptyState(r, context)
                            : ListView.builder(
                                padding: EdgeInsets.only(
                                  left: r.md,
                                  right: r.md,
                                  top: r.sm,
                                  bottom: fabClearance,
                                ),
                                itemCount: widget.exercises.length,
                                itemBuilder: (_, i) => ExerciseCard(
                                  exercise: widget.exercises[i],
                                  onEdit: () => widget.onEdit(i),
                                  onDelete: () => widget.onDelete(i),
                                ),
                              ),
                        WorkoutDaysScreen(
                          key: _workoutDaysKey,
                          workoutDays: widget.workoutDays,
                          allExercises: widget.exercises,
                          onDaysChanged: widget.onDaysChanged,
                          bottomPadding: fabClearance,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(Responsive r, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: EdgeInsets.all(r.lg),
      child: Column(
        children: [
          SizedBox(height: r.lg),
          Container(
            width: r.sp(72),
            height: r.sp(72),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.card,
              border: Border.all(color: cs.border2, width: 0.5),
            ),
            child: Icon(
              Icons.fitness_center_rounded,
              size: r.sp(32),
              color: cs.textMuted,
            ),
          ),
          SizedBox(height: r.lg),
          Text(
            'NO EXERCISES YET',
            style: GoogleFonts.rajdhani(
              fontSize: r.sp(16),
              color: cs.textMuted,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: r.sm),
          Text(
            'Add exercises manually or start\nwith a beginner template below.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: r.sp(13),
              color: cs.textMuted,
              height: 1.6,
            ),
          ),
          SizedBox(height: r.xl),
          GestureDetector(
            onTap: () => _showTemplatesSheet(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(r.lg),
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: cs.lime.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: r.sp(44),
                    height: r.sp(44),
                    decoration: BoxDecoration(
                      color: cs.lime.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.bolt_rounded,
                      color: cs.lime,
                      size: r.sp(24),
                    ),
                  ),
                  SizedBox(width: r.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'START WITH A PLAN',
                          style: GoogleFonts.rajdhani(
                            fontSize: r.sp(13),
                            color: cs.lime,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: r.xs / 2),
                        Text(
                          '3 beginner-friendly templates\nwith exercise tips included',
                          style: TextStyle(
                            fontSize: r.sp(12),
                            color: cs.textSec,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: r.sp(14),
                    color: cs.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Add Exercise Sheet

class _AddExerciseSheet extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController setsController;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final VoidCallback onAdd;

  const _AddExerciseSheet({
    required this.nameController,
    required this.setsController,
    required this.repsController,
    required this.weightController,
    required this.onAdd,
  });

  @override
  State<_AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends State<_AddExerciseSheet> {
  String _selectedMuscle = '';
  final _notesController = TextEditingController();

  static const _muscles = [
    'Chest',
    'Back',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Core',
    'Quads',
    'Hamstrings',
    'Glutes',
    'Calves',
    'Full Body',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(r.lg, r.md, r.lg, r.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: r.w(10),
              height: 3,
              decoration: BoxDecoration(
                color: cs.border2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: r.lg),
          Text(
            'ADD EXERCISE',
            style: GoogleFonts.rajdhani(
              fontSize: r.sp(11),
              color: cs.lime,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: r.xs / 2),
          Text(
            'NEW ENTRY',
            style: GoogleFonts.rajdhani(
              fontSize: r.sp(28),
              fontWeight: FontWeight.w700,
              color: cs.textPri,
              height: 1,
            ),
          ),
          SizedBox(height: r.lg),
          TextField(
            controller: widget.nameController,
            style: GoogleFonts.dmSans(color: cs.textPri, fontSize: r.sp(15)),
            decoration: InputDecoration(
              hintText: 'e.g. Bench Press',
              labelText: 'EXERCISE NAME',
              prefixIcon: Icon(
                Icons.fitness_center_rounded,
                size: r.sp(18),
                color: cs.textMuted,
              ),
            ),
          ),
          SizedBox(height: r.sm),
          Row(
            children: [
              Expanded(
                child: _numField(r, cs, 'SETS', widget.setsController, '3'),
              ),
              SizedBox(width: r.sm),
              Expanded(
                child: _numField(r, cs, 'REPS', widget.repsController, '10'),
              ),
              SizedBox(width: r.sm),
              Expanded(
                child: _numField(
                  r,
                  cs,
                  'KG',
                  widget.weightController,
                  '60',
                  decimal: true,
                ),
              ),
            ],
          ),
          SizedBox(height: r.lg),
          Text(
            'MUSCLE GROUP',
            style: GoogleFonts.rajdhani(
              fontSize: r.sp(10),
              color: cs.textMuted,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: r.sm),
          Wrap(
            spacing: r.xs,
            runSpacing: r.xs,
            children: _muscles.map((m) {
              final selected = _selectedMuscle == m;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedMuscle = selected ? '' : m);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: EdgeInsets.symmetric(
                    horizontal: r.sm,
                    vertical: r.xs,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? cs.lime.withValues(alpha: 0.15) : cs.card,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected ? cs.lime : cs.border2,
                      width: selected ? 1 : 0.5,
                    ),
                  ),
                  child: Text(
                    m,
                    style: GoogleFonts.dmSans(
                      fontSize: r.sp(12),
                      color: selected ? cs.lime : cs.textSec,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: r.lg),
          TextField(
            controller: _notesController,
            style: GoogleFonts.dmSans(color: cs.textSec, fontSize: r.sp(13)),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Form cues or tips (optional)',
              labelText: 'EXERCISE NOTES',
              prefixIcon: Icon(
                Icons.info_outline_rounded,
                size: r.sp(18),
                color: cs.textMuted,
              ),
            ),
          ),
          SizedBox(height: r.xl),
          SizedBox(
            width: double.infinity,
            height: r.h(7).clamp(52.0, 64.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.lime,
                foregroundColor: cs.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: widget.onAdd,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, size: r.sp(18), color: cs.onPrimary),
                  SizedBox(width: r.xs),
                  Text(
                    'SAVE TO LIBRARY',
                    style: GoogleFonts.rajdhani(
                      fontSize: r.sp(15),
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _numField(
    Responsive r,
    ColorScheme cs,
    String label,
    TextEditingController controller,
    String hint, {
    bool decimal = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: decimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      textAlign: TextAlign.center,
      style: GoogleFonts.jetBrainsMono(
        color: cs.textPri,
        fontSize: r.sp(16),
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: cs.textMuted, fontSize: r.sp(13)),
      ),
    );
  }
}

// Templates Sheet

class _TemplatesSheet extends StatelessWidget {
  final void Function(StarterTemplate) onLoad;

  const _TemplatesSheet({required this.onLoad});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(r.lg, r.md, r.lg, 0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: r.w(10),
                      height: 3,
                      decoration: BoxDecoration(
                        color: cs.border2,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: r.lg),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STARTER PLANS',
                              style: GoogleFonts.rajdhani(
                                fontSize: r.sp(11),
                                color: cs.lime,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'CHOOSE A TEMPLATE',
                              style: GoogleFonts.rajdhani(
                                fontSize: r.sp(24),
                                fontWeight: FontWeight.w700,
                                color: cs.textPri,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: r.sm),
                  Text(
                    'Loading a template replaces your current library.',
                    style: TextStyle(fontSize: r.sp(12), color: cs.textMuted),
                  ),
                  SizedBox(height: r.md),
                  Container(height: 0.5, color: cs.border),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: EdgeInsets.all(r.lg),
                itemCount: starterTemplates.length,
                itemBuilder: (_, i) {
                  final t = starterTemplates[i];
                  return Container(
                    margin: EdgeInsets.only(bottom: r.md),
                    decoration: BoxDecoration(
                      color: cs.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.border, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(r.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    t.name,
                                    style: GoogleFonts.rajdhani(
                                      fontSize: r.sp(17),
                                      fontWeight: FontWeight.w700,
                                      color: cs.textPri,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: r.sm,
                                      vertical: r.xs / 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cs.lime.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: cs.lime.withValues(alpha: 0.3),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      t.level,
                                      style: GoogleFonts.rajdhani(
                                        fontSize: r.sp(10),
                                        color: cs.lime,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: r.xs),
                              Text(
                                t.description,
                                style: TextStyle(
                                  fontSize: r.sp(13),
                                  color: cs.textSec,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: r.sm),
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule_rounded,
                                    size: r.sp(13),
                                    color: cs.textMuted,
                                  ),
                                  SizedBox(width: r.xs),
                                  Text(
                                    t.frequency,
                                    style: TextStyle(
                                      fontSize: r.sp(12),
                                      color: cs.textMuted,
                                    ),
                                  ),
                                  SizedBox(width: r.md),
                                  Icon(
                                    Icons.fitness_center_rounded,
                                    size: r.sp(13),
                                    color: cs.textMuted,
                                  ),
                                  SizedBox(width: r.xs),
                                  Text(
                                    '${t.exercises.length} exercises',
                                    style: TextStyle(
                                      fontSize: r.sp(12),
                                      color: cs.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: r.sm),
                              Wrap(
                                spacing: r.xs,
                                runSpacing: r.xs,
                                children: t.exercises
                                    .map((e) => e.muscleGroup)
                                    .toSet()
                                    .map((m) => MuscleBadge(muscleGroup: m))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        Container(height: 0.5, color: cs.border),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            onLoad(t);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: r.md),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.download_rounded,
                                  color: cs.lime,
                                  size: r.sp(16),
                                ),
                                SizedBox(width: r.xs),
                                Text(
                                  'LOAD THIS PLAN',
                                  style: GoogleFonts.rajdhani(
                                    fontSize: r.sp(13),
                                    color: cs.lime,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
