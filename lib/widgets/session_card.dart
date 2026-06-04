import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';
import '../core/theme/app_theme.dart';
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

  Widget _chip(Responsive r, ColorScheme cs, String text, {Color? color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.sm, vertical: r.xs),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cs.border2, width: 0.5),
      ),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: r.sp(11),
          color: color ?? cs.textSec,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
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
          color: done ? cs.elevated : cs.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: done ? cs.border2 : cs.border, width: 0.5),
          boxShadow: cs.brightness == Brightness.light && !done
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: ValueListenableBuilder<WeightUnit>(
          valueListenable: unitNotifier,
          builder: (context, unit, _) {
            final targetDisplay = toDisplayWeight(ex.weight, unit);
            final targetStr = targetDisplay % 1 == 0
                ? targetDisplay.toInt().toString()
                : targetDisplay.toStringAsFixed(1);
            final unitStr = unit == WeightUnit.kg ? 'kg' : 'lbs';

            return Row(
              children: [
                // Index + circle toggle
                Column(
                  children: [
                    Text(
                      (index + 1).toString().padLeft(2, '0'),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: r.sp(10),
                        color: cs.textMuted,
                      ),
                    ),
                    SizedBox(height: r.xs),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: r.sp(28),
                      height: r.sp(28),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? cs.lime : Colors.transparent,
                        border: done
                            ? null
                            : Border.all(color: cs.border2, width: 1.5),
                      ),
                      child: done
                          ? Icon(
                              Icons.check_rounded,
                              color: const Color(0xFF0A0A0A),
                              size: r.sp(14),
                            )
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
                          color: done ? cs.textMuted : cs.textPri,
                          decoration: done ? TextDecoration.lineThrough : null,
                          decorationColor: cs.textMuted,
                        ),
                        child: Text(
                          ex.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: r.xs),
                      Wrap(
                        spacing: r.xs,
                        runSpacing: r.xs,
                        children: [
                          _chip(r, cs, '${ex.sets} × ${ex.reps}'),
                          _chip(r, cs, '$targetStr $unitStr target'),
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
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        toggleUnit();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ACTUAL',
                            style: GoogleFonts.rajdhani(
                              fontSize: r.sp(9),
                              color: cs.textMuted,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(width: r.xs / 2),
                          Icon(
                            Icons.swap_horiz_rounded,
                            size: r.sp(10),
                            color: cs.lime,
                          ),
                          SizedBox(width: r.xs / 2),
                          Text(
                            unitStr.toUpperCase(),
                            style: GoogleFonts.rajdhani(
                              fontSize: r.sp(9),
                              color: cs.lime,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: r.xs / 2),
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
                          color: cs.lime,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          suffixText: unitStr,
                          suffixStyle: TextStyle(
                            color: cs.textMuted,
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
            );
          },
        ),
      ),
    );
  }
}
