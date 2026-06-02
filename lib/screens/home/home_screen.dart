import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';

class HomeScreen extends StatelessWidget {
  final int exerciseCount;
  final int sessionCount;
  final int doneCount;
  final VoidCallback onShuffle;

  const HomeScreen({
    super.key,
    required this.exerciseCount,
    required this.sessionCount,
    required this.doneCount,
    required this.onShuffle,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

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
                        color: kLime,
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
                        color: kTextPri,
                        height: 0.92,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),

                // Avatar circle
                Container(
                  width: r.sp(46),
                  height: r.sp(46),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kCard,
                    border: Border.all(color: kLime, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      'WS',
                      style: GoogleFonts.rajdhani(
                        fontSize: r.sp(14),
                        fontWeight: FontWeight.bold,
                        color: kLime,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: r.xl),

            // Stats row — full width, 3 equal columns
            Row(
              children: [
                Expanded(child: _compactStat(r, 'EXERCISES', '$exerciseCount')),
                SizedBox(width: r.sm),
                Expanded(child: _compactStat(r, 'IN SESSION', '$sessionCount')),
                SizedBox(width: r.sm),
                Expanded(child: _compactStat(r, 'DONE', '$doneCount')),
              ],
            ),

            SizedBox(height: r.xl),

            // Divider label
            Row(
              children: [
                Container(width: r.w(5), height: 0.5, color: kBorder2),
                SizedBox(width: r.sm),
                Text(
                  'QUICK ACTION',
                  style: GoogleFonts.rajdhani(
                    fontSize: r.sp(10),
                    color: kTextMuted,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(width: r.sm),
                Expanded(child: Container(height: 0.5, color: kBorder2)),
              ],
            ),

            SizedBox(height: r.lg),

            // Primary shuffle CTA
            GestureDetector(
              onTap: onShuffle,
              child: Container(
                width: double.infinity,
                height: r.h(9).clamp(60.0, 76.0),
                decoration: BoxDecoration(
                  color: kLime,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shuffle_rounded, color: kBg, size: r.sp(20)),
                    SizedBox(width: r.sm),
                    Text(
                      'SHUFFLE WORKOUT',
                      style: GoogleFonts.rajdhani(
                        fontSize: r.sp(17),
                        fontWeight: FontWeight.w700,
                        color: kBg,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: r.sm),

            // Secondary hint text
            Center(
              child: Text(
                'Randomises your full exercise list',
                style: TextStyle(fontSize: r.sp(12), color: kTextMuted),
              ),
            ),

            SizedBox(height: r.xl),

            // Motivational block
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(r.lg),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kBorder, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bolt_rounded, color: kLime, size: r.sp(16)),
                      SizedBox(width: r.xs),
                      Text(
                        'CONSISTENCY BEATS INTENSITY',
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(11),
                          color: kLime,
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
                      color: kTextSec,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: r.xl),
          ],
        ),
      ),
    );
  }

  Widget _compactStat(Responsive r, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: r.md, horizontal: r.sm),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.rajdhani(
              fontSize: r.sp(9),
              color: kTextMuted,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: r.xs),
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
