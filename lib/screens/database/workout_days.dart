import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../models/workout_day.dart';
import '../../models/exercise.dart';

class WorkoutDaysScreen extends StatefulWidget {
  final List<WorkoutDay> workoutDays;
  final List<Exercise> allExercises;
  final void Function(List<WorkoutDay>) onDaysChanged;
  final double bottomPadding;

  const WorkoutDaysScreen({
    super.key,
    required this.workoutDays,
    required this.allExercises,
    required this.onDaysChanged,
    this.bottomPadding = 80.0,
  });

  @override
  State<WorkoutDaysScreen> createState() => WorkoutDaysScreenState();
}

class WorkoutDaysScreenState extends State<WorkoutDaysScreen> {
  late List<WorkoutDay> _days;

  @override
  void initState() {
    super.initState();
    _days = List.from(widget.workoutDays);
  }

  void addDay() {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

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
        child: Padding(
          padding: EdgeInsets.fromLTRB(r.lg, r.md, r.lg, r.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                'CREATE DAY',
                style: GoogleFonts.rajdhani(
                  fontSize: r.sp(11),
                  color: cs.lime,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: r.xs / 2),
              Text(
                'NEW SPLIT DAY',
                style: GoogleFonts.rajdhani(
                  fontSize: r.sp(26),
                  fontWeight: FontWeight.w700,
                  color: cs.textPri,
                  height: 1,
                ),
              ),
              SizedBox(height: r.lg),
              TextField(
                controller: nameCtrl,
                style: TextStyle(color: cs.textPri),
                decoration: const InputDecoration(
                  labelText: 'DAY NAME',
                  hintText: 'e.g. Push Day',
                ),
              ),
              SizedBox(height: r.sm),
              TextField(
                controller: descCtrl,
                style: TextStyle(color: cs.textPri),
                decoration: const InputDecoration(
                  labelText: 'DESCRIPTION',
                  hintText: 'e.g. Chest, Shoulders, Triceps',
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
                  onPressed: () {
                    if (nameCtrl.text.isEmpty) return;
                    final newDay = WorkoutDay(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      exerciseNames: [],
                    );
                    setState(() => _days.add(newDay));
                    widget.onDaysChanged(_days);
                    Navigator.pop(context);
                    _editDay(_days.length - 1);
                  },
                  child: Text(
                    'CREATE & ADD EXERCISES',
                    style: GoogleFonts.rajdhani(
                      fontSize: r.sp(15),
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editDay(int index) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final day = _days[index];

    List<String> selected = List.from(day.exerciseNames);

    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(r.lg, r.md, r.lg, 0),
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
                        'EDITING',
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(11),
                          color: cs.lime,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        day.name.toUpperCase(),
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(26),
                          fontWeight: FontWeight.w700,
                          color: cs.textPri,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: r.xs),
                      Text(
                        'Tap exercises to add or remove from this day',
                        style: TextStyle(
                          fontSize: r.sp(12),
                          color: cs.textMuted,
                        ),
                      ),
                      SizedBox(height: r.md),
                      Container(height: 0.5, color: cs.border),
                    ],
                  ),
                ),
                Expanded(
                  child: widget.allExercises.isEmpty
                      ? Center(
                          child: Text(
                            'No exercises in library yet',
                            style: TextStyle(
                              color: cs.textMuted,
                              fontSize: r.sp(14),
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: controller,
                          padding: EdgeInsets.all(r.md),
                          itemCount: widget.allExercises.length,
                          itemBuilder: (_, i) {
                            final ex = widget.allExercises[i];
                            final isSelected = selected.contains(ex.name);
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setModalState(() {
                                  isSelected
                                      ? selected.remove(ex.name)
                                      : selected.add(ex.name);
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: EdgeInsets.only(bottom: r.sm),
                                padding: EdgeInsets.all(r.md),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? cs.lime.withValues(alpha: 0.1)
                                      : cs.card,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? cs.lime : cs.border,
                                    width: isSelected ? 1 : 0.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 150,
                                      ),
                                      width: r.sp(24),
                                      height: r.sp(24),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? cs.lime
                                            : Colors.transparent,
                                        border: isSelected
                                            ? null
                                            : Border.all(
                                                color: cs.border2,
                                                width: 1.5,
                                              ),
                                      ),
                                      child: isSelected
                                          ? Icon(
                                              Icons.check_rounded,
                                              color: const Color(0xFF0A0A0A),
                                              size: r.sp(14),
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: r.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ex.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.dmSans(
                                              fontSize: r.sp(14),
                                              fontWeight: FontWeight.w600,
                                              color: isSelected
                                                  ? cs.textPri
                                                  : cs.textSec,
                                            ),
                                          ),
                                          Text(
                                            '${ex.sets} sets × ${ex.reps} reps',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: r.sp(12),
                                              color: cs.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: r.xs),
                                    Text(
                                      '${ex.weight}kg',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: r.sp(13),
                                        color: cs.lime,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(r.lg, 0, r.lg, r.xl),
                  child: SizedBox(
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
                      onPressed: () {
                        setState(() {
                          _days[index] = WorkoutDay(
                            id: day.id,
                            name: day.name,
                            description: day.description,
                            exerciseNames: selected,
                          );
                        });
                        widget.onDaysChanged(_days);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'SAVE — ${selected.length} EXERCISES',
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(15),
                          fontWeight: FontWeight.w700,
                          color: cs.onPrimary,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteDay(int index) {
    final cs = Theme.of(context).colorScheme;
    final r = Responsive(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text(
          'DELETE DAY',
          style: GoogleFonts.rajdhani(
            fontSize: r.sp(16),
            fontWeight: FontWeight.w700,
            color: cs.textPri,
            letterSpacing: 1,
          ),
        ),
        content: Text(
          'Remove "${_days[index].name}"?',
          style: TextStyle(fontSize: r.sp(14), color: cs.textSec),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL', style: TextStyle(color: cs.textMuted)),
          ),
          TextButton(
            onPressed: () {
              setState(() => _days.removeAt(index));
              widget.onDaysChanged(_days);
              Navigator.pop(context);
            },
            child: const Text(
              'DELETE',
              style: TextStyle(color: Color(0xFFFF4444)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        color: cs.bg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(r.lg, r.lg, r.lg, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SPLITS',
                    style: GoogleFonts.rajdhani(
                      fontSize: r.sp(11),
                      color: cs.lime,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: r.xs / 2),
                  Text(
                    'WORKOUT DAYS',
                    style: GoogleFonts.rajdhani(
                      fontSize: r.sp(32),
                      fontWeight: FontWeight.w700,
                      color: cs.textPri,
                      height: 1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: r.xs),
                  Text(
                    'Group exercises into Push, Pull, Legs or any split',
                    style: TextStyle(fontSize: r.sp(13), color: cs.textMuted),
                  ),
                  SizedBox(height: r.md),
                  Container(height: 0.5, color: cs.border),
                ],
              ),
            ),
            SizedBox(height: r.md),
            Expanded(
              child: _days.isEmpty
                  ? _buildEmptyState(r, cs)
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        left: r.md,
                        right: r.md,
                        bottom: widget.bottomPadding,
                      ),
                      itemCount: _days.length,
                      itemBuilder: (_, i) => _buildDayCard(r, cs, i),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(Responsive r, ColorScheme cs, int index) {
    final day = _days[index];
    final exerciseCount = day.exerciseNames.length;

    return Container(
      margin: EdgeInsets.only(bottom: r.sm),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.border, width: 0.5),
        boxShadow: cs.brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(r.md),
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
                    Icons.calendar_today_rounded,
                    color: cs.lime,
                    size: r.sp(20),
                  ),
                ),
                SizedBox(width: r.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(17),
                          fontWeight: FontWeight.w700,
                          color: cs.textPri,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (day.description.isNotEmpty)
                        Text(
                          day.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: r.sp(12),
                            color: cs.textSec,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: r.xs),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.sm,
                    vertical: r.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: cs.border2, width: 0.5),
                  ),
                  child: Text(
                    '$exerciseCount ex',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: r.sp(11),
                      color: cs.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: cs.border, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _editDay(index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: r.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: r.sp(14),
                            color: cs.lime,
                          ),
                          SizedBox(width: r.xs),
                          Text(
                            'EDIT EXERCISES',
                            style: GoogleFonts.rajdhani(
                              fontSize: r.sp(12),
                              color: cs.lime,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(width: 0.5, height: r.h(5), color: cs.border),
                GestureDetector(
                  onTap: () => _deleteDay(index),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.lg,
                      vertical: r.sm,
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: r.sp(18),
                      color: const Color(0xFFFF4444),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Responsive r, ColorScheme cs) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: r.xl,
          right: r.xl,
          top: r.xl,
          bottom: widget.bottomPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: r.sp(72),
              height: r.sp(72),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.card,
                border: Border.all(color: cs.border2, width: 0.5),
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                size: r.sp(30),
                color: cs.textMuted,
              ),
            ),
            SizedBox(height: r.lg),
            Text(
              'NO SPLIT DAYS YET',
              style: GoogleFonts.rajdhani(
                fontSize: r.sp(16),
                color: cs.textMuted,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: r.sm),
            Text(
              'Create Push Day, Pull Day, Legs Day\nor any split you follow',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: r.sp(13),
                color: cs.textMuted,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
