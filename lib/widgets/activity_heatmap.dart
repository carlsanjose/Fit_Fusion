import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/responsive.dart';
import '../models/workout_log.dart';

class ActivityHeatmap extends StatelessWidget {
  final List<WorkoutLog> logs;

  const ActivityHeatmap({super.key, required this.logs});

  // Returns intensity 0–3 for a given date
  int _intensity(DateTime day) {
    final match = logs.where(
      (l) =>
          l.date.year == day.year &&
          l.date.month == day.month &&
          l.date.day == day.day,
    );
    if (match.isEmpty) return 0;
    final log = match.first;
    if (log.completedCount == 0) return 0;
    final ratio = log.completedCount / log.exerciseCount;
    if (ratio < 0.34) return 1;
    if (ratio < 0.67) return 2;
    return 3;
  }

  Color _cellColor(int intensity, ColorScheme cs) {
    final isDark = cs.brightness == Brightness.dark;
    if (intensity == 0) {
      return isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE8E8E8);
    }
    // Use lime in dark, forest green in light — same as cs.lime
    final base = cs.lime;
    switch (intensity) {
      case 1:
        return base.withValues(alpha: 0.25);
      case 2:
        return base.withValues(alpha: 0.55);
      case 3:
        return base;
      default:
        return base;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;

    // Build 16 weeks of dates ending today
    final today = DateTime.now();
    final weeks = 16;
    // Start from the most recent Sunday going back 16 weeks
    final startDay = today.subtract(
      Duration(days: today.weekday % 7 + (weeks - 1) * 7),
    );

    final cellSize = r.w(4.8).clamp(14.0, 20.0);
    final cellGap = 3.0;

    // Day labels
    final dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    // Month labels — collect unique months across the grid
    List<String> monthLabels = [];
    List<int> monthPositions = [];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    int? lastMonth;
    for (int w = 0; w < weeks; w++) {
      final weekStart = startDay.add(Duration(days: w * 7));
      if (weekStart.month != lastMonth) {
        monthLabels.add(months[weekStart.month - 1]);
        monthPositions.add(w);
        lastMonth = weekStart.month;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ACTIVITY',
              style: GoogleFonts.rajdhani(
                fontSize: r.sp(11),
                color: cs.lime,
                letterSpacing: 3,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${logs.length} sessions logged',
              style: GoogleFonts.jetBrainsMono(
                fontSize: r.sp(11),
                color: cs.textMuted,
              ),
            ),
          ],
        ),
        SizedBox(height: r.sm),

        // Month labels row
        SizedBox(
          height: 14,
          child: Stack(
            children: List.generate(monthLabels.length, (i) {
              final leftOffset = monthPositions[i] * (cellSize + cellGap) + 18;
              return Positioned(
                left: leftOffset,
                child: Text(
                  monthLabels[i],
                  style: GoogleFonts.rajdhani(
                    fontSize: r.sp(9),
                    color: cs.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
              );
            }),
          ),
        ),

        SizedBox(height: 4),

        // Grid
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day labels column
            Column(
              children: List.generate(
                7,
                (d) => Padding(
                  padding: EdgeInsets.only(bottom: cellGap),
                  child: SizedBox(
                    width: 14,
                    height: cellSize,
                    child: Center(
                      child: Text(
                        // Only show M, W, F
                        [1, 3, 5].contains(d) ? dayLabels[d] : '',
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(8),
                          color: cs.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 4),

            // Weeks
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true, // show most recent on right
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(weeks, (w) {
                    return Padding(
                      padding: EdgeInsets.only(right: cellGap),
                      child: Column(
                        children: List.generate(7, (d) {
                          final day = startDay.add(Duration(days: w * 7 + d));
                          final isFuture = day.isAfter(today);
                          final intensity = isFuture ? -1 : _intensity(day);
                          final isToday =
                              day.year == today.year &&
                              day.month == today.month &&
                              day.day == today.day;

                          return Padding(
                            padding: EdgeInsets.only(bottom: cellGap),
                            child: Tooltip(
                              message: isFuture
                                  ? ''
                                  : intensity == 0
                                  ? 'No workout'
                                  : 'Worked out',
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: cellSize,
                                height: cellSize,
                                decoration: BoxDecoration(
                                  color: isFuture
                                      ? Colors.transparent
                                      : _cellColor(intensity, cs),
                                  borderRadius: BorderRadius.circular(3),
                                  border: isToday
                                      ? Border.all(color: cs.lime, width: 1.5)
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: r.sm),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'LESS',
              style: GoogleFonts.rajdhani(
                fontSize: r.sp(9),
                color: cs.textMuted,
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: r.xs),
            ...List.generate(
              4,
              (i) => Padding(
                padding: EdgeInsets.only(right: 3),
                child: Container(
                  width: cellSize * 0.75,
                  height: cellSize * 0.75,
                  decoration: BoxDecoration(
                    color: _cellColor(i, cs),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            SizedBox(width: r.xs),
            Text(
              'MORE',
              style: GoogleFonts.rajdhani(
                fontSize: r.sp(9),
                color: cs.textMuted,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
