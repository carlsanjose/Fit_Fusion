import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Container(
      width: r.w(33), // ~33% of screen width each
      height: r.h(11), // ~11% of screen height
      padding: EdgeInsets.all(r.md),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.rajdhani(
              fontSize: r.sp(11),
              color: kTextSec,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: r.sp(26),
              color: kTextPri,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
