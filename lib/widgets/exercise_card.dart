import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/responsive.dart';
import '../models/exercise.dart';
import 'muscle_badge.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onEdit,
    required this.onDelete,
  });

  void _confirmDelete(BuildContext context, Responsive r, ColorScheme cs) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'DELETE EXERCISE',
          style: GoogleFonts.rajdhani(
            fontSize: r.sp(16),
            fontWeight: FontWeight.w700,
            color: cs.textPri,
            letterSpacing: 1,
          ),
        ),
        content: Text(
          'Remove "${exercise.name}" from your library?',
          style: GoogleFonts.dmSans(
            fontSize: r.sp(14),
            color: cs.textSec,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: GoogleFonts.rajdhani(
                fontSize: r.sp(13),
                color: cs.textMuted,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text(
              'DELETE',
              style: GoogleFonts.rajdhani(
                fontSize: r.sp(13),
                color: const Color(0xFFFF4444),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
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

    return Dismissible(
      key: Key(exercise.name + exercise.hashCode.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        bool confirmed = false;
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: cs.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'DELETE EXERCISE',
              style: GoogleFonts.rajdhani(
                fontSize: r.sp(16),
                fontWeight: FontWeight.w700,
                color: cs.textPri,
                letterSpacing: 1,
              ),
            ),
            content: Text(
              'Remove "${exercise.name}" from your library?',
              style: GoogleFonts.dmSans(
                fontSize: r.sp(14),
                color: cs.textSec,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  confirmed = false;
                  Navigator.pop(context);
                },
                child: Text(
                  'CANCEL',
                  style: GoogleFonts.rajdhani(
                    fontSize: r.sp(13),
                    color: cs.textMuted,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  confirmed = true;
                  Navigator.pop(context);
                },
                child: Text(
                  'DELETE',
                  style: GoogleFonts.rajdhani(
                    fontSize: r.sp(13),
                    color: const Color(0xFFFF4444),
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
        return confirmed;
      },
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onDelete();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: r.lg),
        margin: EdgeInsets.only(bottom: r.sm),
        decoration: BoxDecoration(
          color: const Color(0xFFFF4444),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: r.sp(22),
            ),
            SizedBox(height: r.xs / 2),
            Text(
              'DELETE',
              style: GoogleFonts.rajdhani(
                fontSize: r.sp(10),
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: r.sm),
        padding: EdgeInsets.all(r.md),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onEdit();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        fontSize: r.sp(15),
                        fontWeight: FontWeight.w600,
                        color: cs.textPri,
                      ),
                    ),
                    SizedBox(height: r.xs),
                    Wrap(
                      spacing: r.xs,
                      runSpacing: r.xs,
                      children: [
                        _pill(r, cs, '${exercise.sets} sets'),
                        _pill(r, cs, '${exercise.reps} reps'),
                        if (exercise.muscleGroup.isNotEmpty)
                          MuscleBadge(muscleGroup: exercise.muscleGroup),
                      ],
                    ),
                    if (exercise.notes.isNotEmpty) ...[
                      SizedBox(height: r.sm),
                      Text(
                        exercise.notes,
                        style: TextStyle(
                          fontSize: r.sp(12),
                          color: cs.textMuted,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(width: r.sm),

            // Right — weight + actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Weight display with per-exercise toggle
                ValueListenableBuilder<WeightUnit>(
                  valueListenable: unitNotifier,
                  builder: (context, unit, _) {
                    final displayVal = toDisplayWeight(exercise.weight, unit);
                    final displayStr = displayVal % 1 == 0
                        ? displayVal.toInt().toString()
                        : displayVal.toStringAsFixed(1);

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
                          border: Border.all(color: cs.border2, width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              displayStr,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: r.sp(24),
                                color: cs.lime,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  unitLabel(unit),
                                  style: TextStyle(
                                    color: cs.lime,
                                    fontSize: r.sp(10),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: r.xs / 2),
                                Icon(
                                  Icons.swap_horiz_rounded,
                                  size: r.sp(10),
                                  color: cs.textMuted,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: r.sm),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onEdit();
                      },
                      child: Container(
                        padding: EdgeInsets.all(r.xs),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: cs.border2, width: 0.5),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          size: r.sp(14),
                          color: cs.textSec,
                        ),
                      ),
                    ),
                    SizedBox(width: r.xs),
                    GestureDetector(
                      onTap: () => _confirmDelete(context, r, cs),
                      child: Container(
                        padding: EdgeInsets.all(r.xs),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4444).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(
                              0xFFFF4444,
                            ).withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: r.sp(14),
                          color: const Color(0xFFFF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(Responsive r, ColorScheme cs, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.sm, vertical: r.xs / 2),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cs.border2, width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: r.sp(11), color: cs.textSec),
      ),
    );
  }
}
