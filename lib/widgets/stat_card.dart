import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/responsive.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: r.w(33), // ~33% of screen width each
      height: r.h(11), // ~11% of screen height
      padding: EdgeInsets.all(r.md),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.rajdhani(
              fontSize: r.sp(11),
              color: cs.textSec,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
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
