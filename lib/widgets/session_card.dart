import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive.dart';
import '../models/active_exercise.dart';

class SessionCard extends StatelessWidget {
  final ActiveExercise activeExercise;
  final int index;
  final VoidCallback onToggle;
  final VoidCallback onWeightChanged;

  const SessionCard({
    super.key,
    required this.activeExercise,
    required this.index,
    required this.onToggle,
    required this.onWeightChanged,
  });

  Widget _chip(Responsive r, String text, {Color color = kTextSec}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.sm, vertical: r.xs),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: kBorder2, width: 0.5),
      ),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(fontSize: r.sp(11), color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final ex = activeExercise.exercise;
    final done = activeExercise.isDone;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onToggle();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: r.sm),
        padding: EdgeInsets.all(r.md),
        decoration: BoxDecoration(
          color: done ? kSurface : kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: done ? kBorder : kBorder2, width: 0.5),
        ),
        child: Row(
          children: [
            // Index number + checkbox combined
            Column(
              children: [
                Text(
                  (index + 1).toString().padLeft(2, '0'),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: r.sp(10),
                    color: kTextMuted,
                  ),
                ),
                SizedBox(height: r.xs),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: r.sp(28),
                  height: r.sp(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? kLime : Colors.transparent,
                    border: done
                        ? null
                        : Border.all(color: kBorder2, width: 1.5),
                  ),
                  child: done
                      ? Icon(Icons.check_rounded, color: kBg, size: r.sp(14))
                      : null,
                ),
              ],
            ),

            SizedBox(width: r.md),

            // Exercise info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: GoogleFonts.dmSans(
                      fontSize: r.sp(15),
                      fontWeight: FontWeight.w600,
                      color: done ? kTextMuted : kTextPri,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: kTextMuted,
                    ),
                    child: Text(ex.name),
                  ),
                  SizedBox(height: r.xs),
                  Row(
                    children: [
                      _chip(r, '${ex.sets} × ${ex.reps}'),
                      SizedBox(width: r.xs),
                      _chip(r, '${ex.weight} kg target'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: r.sm),

            // Actual weight input
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'ACTUAL',
                  style: GoogleFonts.rajdhani(
                    fontSize: r.sp(9),
                    color: kTextMuted,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(
                  width: r.w(18),
                  child: TextField(
                    controller: activeExercise.weightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) => onWeightChanged(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: r.sp(15),
                      color: kLime,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      suffixText: 'kg',
                      suffixStyle: TextStyle(
                        color: kTextMuted,
                        fontSize: r.sp(10),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: r.sm,
                        vertical: r.sm,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
