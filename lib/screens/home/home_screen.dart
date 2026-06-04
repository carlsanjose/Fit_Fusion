import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../models/workout_log.dart';
import '../../widgets/activity_heatmap.dart';

class HomeScreen extends StatelessWidget {
  final int exerciseCount;
  final int sessionCount;
  final int doneCount;
  final VoidCallback onShuffle;
  final List<WorkoutLog> workoutLogs;

  const HomeScreen({
    super.key,
    required this.exerciseCount,
    required this.sessionCount,
    required this.doneCount,
    required this.onShuffle,
    required this.workoutLogs,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: r.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: r.lg),

            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TODAY',
                      style: GoogleFonts.rajdhani(
                        fontSize: r.sp(11),
                        color: cs.lime, // ← was kLime
                        letterSpacing: 3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: r.xs / 2),
                    Text(
                      "LET'S\nWORK.",
                      style: GoogleFonts.rajdhani(
                        fontSize: r.sp(44),
                        fontWeight: FontWeight.w700,
                        color: cs.textPri,
                        height: 0.92,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    // Theme toggle
                    GestureDetector(
                      onTap: toggleTheme,
                      child: Container(
                        width: r.sp(40),
                        height: r.sp(40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.card,
                          border: Border.all(color: cs.border2, width: 0.5),
                          boxShadow: cs.brightness == Brightness.light
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Icon(
                            cs.brightness == Brightness.dark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            color: cs.textSec,
                            size: r.sp(18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: r.sm),
                    // Avatar
                    Container(
                      width: r.sp(40),
                      height: r.sp(40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.card,
                        border: Border.all(
                          color: cs.lime,
                          width: 1.5,
                        ), // ← was kLime
                        boxShadow: cs.brightness == Brightness.light
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          'WS',
                          style: GoogleFonts.rajdhani(
                            fontSize: r.sp(13),
                            fontWeight: FontWeight.bold,
                            color: cs.lime, // ← was kLime
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: r.xl),

            // Stats row
            Row(
              children: [
                Expanded(
                  child: _compactStat(r, cs, 'EXERCISES', '$exerciseCount'),
                ),
                SizedBox(width: r.sm),
                Expanded(
                  child: _compactStat(r, cs, 'IN SESSION', '$sessionCount'),
                ),
                SizedBox(width: r.sm),
                Expanded(child: _compactStat(r, cs, 'DONE', '$doneCount')),
              ],
            ),

            SizedBox(height: r.xl),

            // Divider label
            Row(
              children: [
                Container(width: r.w(5), height: 0.5, color: cs.border2),
                SizedBox(width: r.sm),
                Text(
                  'QUICK ACTION',
                  style: GoogleFonts.rajdhani(
                    fontSize: r.sp(10),
                    color: cs.textMuted,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(width: r.sm),
                Expanded(child: Container(height: 0.5, color: cs.border2)),
              ],
            ),

            SizedBox(height: r.lg),

            // Shuffle CTA
            GestureDetector(
              onTap: onShuffle,
              child: Container(
                width: double.infinity,
                height: r.h(9).clamp(60.0, 76.0),
                decoration: BoxDecoration(
                  color: cs.lime,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: cs.brightness == Brightness.light
                      ? [
                          BoxShadow(
                            color: cs.lime.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shuffle_rounded,
                      color: cs.onPrimary,
                      size: r.sp(20),
                    ),
                    SizedBox(width: r.sm),
                    Text(
                      'SHUFFLE WORKOUT',
                      style: GoogleFonts.rajdhani(
                        fontSize: r.sp(17),
                        fontWeight: FontWeight.w700,
                        color: cs.onPrimary,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: r.sm),

            Center(
              child: Text(
                'Randomises your full exercise list',
                style: TextStyle(fontSize: r.sp(12), color: cs.textMuted),
              ),
            ),

            SizedBox(height: r.xl),

            // Motivational block
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(r.lg),
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: BorderRadius.circular(16),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bolt_rounded, color: cs.lime, size: r.sp(16)),
                      SizedBox(width: r.xs),
                      Text(
                        'CONSISTENCY BEATS INTENSITY',
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(11),
                          color: cs.lime,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: r.sm),
                  Text(
                    'Show up. Load the bar. Keep moving.',
                    style: GoogleFonts.dmSans(
                      fontSize: r.sp(15),
                      color: cs.textSec,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: r.xl),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(r.lg),
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: BorderRadius.circular(16),
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
              child: ActivityHeatmap(logs: workoutLogs),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compactStat(
    Responsive r,
    ColorScheme cs,
    String label,
    String value,
  ) {
    final isDark = cs.brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(vertical: r.md, horizontal: r.sm),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.border, width: 0.5),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.rajdhani(
              fontSize: r.sp(9),
              color: isDark ? cs.textMuted : cs.textSec,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: r.xs),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: r.sp(26),
              color: cs.textPri,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
