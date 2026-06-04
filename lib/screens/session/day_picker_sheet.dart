import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../models/workout_day.dart';
import '../../models/exercise.dart';

class DayPickerSheet extends StatelessWidget {
  final List<WorkoutDay> workoutDays;
  final List<Exercise> allExercises;
  final void Function(WorkoutDay day) onDaySelected;
  final VoidCallback onShuffleAll;

  const DayPickerSheet({
    super.key,
    required this.workoutDays,
    required this.allExercises,
    required this.onDaySelected,
    required this.onShuffleAll,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: cs.border, width: 0.5),
        ),
        child: Column(
          children: [
            // Handle + header
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LOAD SESSION',
                            style: GoogleFonts.rajdhani(
                              fontSize: r.sp(11),
                              color: cs.lime,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "WHAT'S TODAY?",
                            style: GoogleFonts.rajdhani(
                              fontSize: r.sp(26),
                              fontWeight: FontWeight.w700,
                              color: cs.textPri,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: r.md),
                  Container(height: 0.5, color: cs.border),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                controller: controller,
                padding: EdgeInsets.all(r.lg),
                children: [
                  // Shuffle all option
                  _buildOption(
                    context: context,
                    r: r,
                    cs: cs,
                    icon: Icons.shuffle_rounded,
                    iconColor: cs.orange,
                    title: 'SHUFFLE ALL',
                    subtitle: 'Random order from your full library',
                    count: '${allExercises.length} exercises',
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      onShuffleAll();
                      Navigator.pop(context);
                    },
                  ),

                  if (workoutDays.isNotEmpty) ...[
                    SizedBox(height: r.md),
                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 0.5, color: cs.border),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: r.sm),
                          child: Text(
                            'YOUR DAYS',
                            style: GoogleFonts.rajdhani(
                              fontSize: r.sp(10),
                              color: cs.textMuted,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(height: 0.5, color: cs.border),
                        ),
                      ],
                    ),
                    SizedBox(height: r.md),
                    ...workoutDays.map((day) {
                      // Find matching exercises
                      final dayExercises = day.exerciseNames
                          .map(
                            (name) => allExercises
                                .where((e) => e.name == name)
                                .firstOrNull,
                          )
                          .whereType<Exercise>()
                          .toList();

                      return Padding(
                        padding: EdgeInsets.only(bottom: r.sm),
                        child: _buildOption(
                          context: context,
                          r: r,
                          cs: cs,
                          icon: Icons.calendar_today_rounded,
                          iconColor: cs.lime,
                          title: day.name.toUpperCase(),
                          subtitle: day.description,
                          count: '${dayExercises.length} exercises',
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            onDaySelected(day);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }),
                  ],

                  // No days yet hint
                  if (workoutDays.isEmpty) ...[
                    SizedBox(height: r.lg),
                    Container(
                      padding: EdgeInsets.all(r.lg),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.border, width: 0.5),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: cs.textMuted,
                            size: r.sp(24),
                          ),
                          SizedBox(height: r.sm),
                          Text(
                            'No workout days yet',
                            style: GoogleFonts.rajdhani(
                              fontSize: r.sp(14),
                              color: cs.textMuted,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: r.xs),
                          Text(
                            'Go to Library → Days tab to create\nyour Push/Pull/Legs split',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: r.sp(12),
                              color: cs.textMuted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required Responsive r,
    required ColorScheme cs,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(r.md),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.border, width: 0.5),
          boxShadow: cs.brightness == Brightness.light
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: r.sp(44),
              height: r.sp(44),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: r.sp(22)),
            ),
            SizedBox(width: r.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.rajdhani(
                      fontSize: r.sp(15),
                      fontWeight: FontWeight.w700,
                      color: cs.textPri,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: r.xs / 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: r.sp(12), color: cs.textSec),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  count,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: r.sp(11),
                    color: cs.textMuted,
                  ),
                ),
                SizedBox(height: r.xs),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: r.sp(12),
                  color: cs.textMuted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
