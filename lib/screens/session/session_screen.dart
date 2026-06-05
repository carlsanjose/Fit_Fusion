import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../models/active_exercise.dart';
import '../../widgets/session_card.dart';

class SessionScreen extends StatelessWidget {
  final List<ActiveExercise> session;
  final VoidCallback onShuffle;
  final void Function(int index) onToggleDone;
  final VoidCallback onWeightChanged;
  final void Function(int seconds) onStartTimer;

  const SessionScreen({
    super.key,
    required this.session,
    required this.onShuffle,
    required this.onToggleDone,
    required this.onWeightChanged,
    required this.onStartTimer,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    final done = session.where((e) => e.isDone).length;
    final total = session.length;
    final pct = total == 0 ? 0.0 : done / total;

    return Scaffold(
      backgroundColor: cs.bg,
      // In session_screen.dart, replace the FAB:
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'timer',
            backgroundColor: cs.surface,
            elevation: 0,
            onPressed: () => onStartTimer(90),
            child: Icon(Icons.timer_rounded, color: cs.lime, size: r.sp(20)),
          ),
          SizedBox(height: r.sm),
          FloatingActionButton(
            heroTag: 'shuffle',
            backgroundColor: cs.orange,
            elevation: 0,
            onPressed: () {
              HapticFeedback.mediumImpact();
              onShuffle();
            },
            child: Icon(
              Icons.shuffle_rounded,
              color: Colors.white,
              size: r.sp(22),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header block
            Padding(
              padding: EdgeInsets.fromLTRB(r.lg, r.lg, r.lg, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ACTIVE',
                            style: GoogleFonts.rajdhani(
                              fontSize: r.sp(11),
                              color: cs.orange,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: r.xs / 2),
                          Text(
                            'SESSION',
                            style: GoogleFonts.rajdhani(
                              fontSize: r.sp(36),
                              fontWeight: FontWeight.w700,
                              color: cs.textPri,
                              height: 1,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),

                      // Progress ring area
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$done',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: r.sp(36),
                              color: done == total && total > 0
                                  ? cs.lime
                                  : cs.textPri,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                          Text(
                            'OF $total',
                            style: GoogleFonts.rajdhani(
                              fontSize: r.sp(11),
                              color: cs.textMuted,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: r.md),

                  // Progress bar
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 4,
                        decoration: BoxDecoration(
                          color: cs.border2,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        width:
                            (MediaQuery.of(context).size.width - r.lg * 2) *
                            pct,
                        height: 4,
                        decoration: BoxDecoration(
                          color: done == total && total > 0
                              ? cs.success
                              : cs.lime,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: r.xs),

                  // Progress label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        done == total && total > 0
                            ? 'WORKOUT COMPLETE 🎉'
                            : '${(pct * 100).toStringAsFixed(0)}% COMPLETE',
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(11),
                          color: done == total && total > 0
                              ? cs.success
                              : cs.textMuted,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        '${total - done} REMAINING',
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(11),
                          color: cs.textMuted,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: r.md),
                  Container(height: 0.5, color: cs.border),
                ],
              ),
            ),

            SizedBox(height: r.sm),

            // List
            Expanded(
              child: session.isEmpty
                  ? _buildEmptyState(r, context)
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: r.md),
                      itemCount: session.length,
                      itemBuilder: (_, i) => SessionCard(
                        activeExercise: session[i],
                        index: i,
                        onToggle: () => onToggleDone(i),
                        onWeightChanged: onWeightChanged,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Responsive r, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(r.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: r.sp(72),
              height: r.sp(72),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.card,
                border: Border.all(color: cs.border2, width: 0.5),
              ),
              child: Icon(
                Icons.shuffle_rounded,
                size: r.sp(30),
                color: cs.textMuted,
              ),
            ),
            SizedBox(height: r.lg),
            Text(
              'NO SESSION LOADED',
              style: GoogleFonts.rajdhani(
                fontSize: r.sp(16),
                color: cs.textMuted,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: r.sm),
            Text(
              'Go to Home and hit Shuffle\nto load a workout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: r.sp(13),
                color: cs.textMuted,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
