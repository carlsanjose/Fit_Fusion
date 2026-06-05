import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/utils/responsive.dart';

class MuscleBadge extends StatelessWidget {
  final String muscleGroup;

  const MuscleBadge({super.key, required this.muscleGroup});

  static Color _color(String group, bool isDark) {
    switch (group.toLowerCase()) {
      case 'chest':
        return const Color(0xFFFF6B6B);
      case 'back':
        return const Color(0xFF4ECDC4);
      case 'shoulders':
        return const Color(0xFFFFE66D);
      case 'biceps':
        return const Color(0xFF6BCB77);
      case 'triceps':
        return const Color(0xFF4D96FF);
      case 'core':
        return const Color(0xFFFF9F1C);
      case 'quads':
        return const Color(0xFFC77DFF);
      case 'hamstrings':
        return const Color(0xFFFF6B35);
      case 'glutes':
        return const Color(0xFFFF87AB);
      case 'calves':
        return const Color(0xFF00B4D8);
      case 'full body':
        return isDark ? const Color(0xFFE8FF47) : const Color(0xFF4A7C59);
      default:
        return const Color(0xFF888888);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (muscleGroup.isEmpty) return const SizedBox.shrink();

    // context is available here inside build()
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _color(muscleGroup, isDark);
    final r = Responsive(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.sm, vertical: r.xs / 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 0.5),
      ),
      child: Text(
        muscleGroup.toUpperCase(),
        style: GoogleFonts.rajdhani(
          fontSize: r.sp(10),
          color: color,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
