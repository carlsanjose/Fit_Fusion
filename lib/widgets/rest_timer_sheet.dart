import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive.dart';
import '../services/timer_service.dart';

class RestTimerSheet extends StatelessWidget {
  final TimerService timerService;
  final VoidCallback onDismiss;

  const RestTimerSheet({
    super.key,
    required this.timerService,
    required this.onDismiss,
  });

  static const List<_Preset> _presets = [
    _Preset(label: '30s', seconds: 30),
    _Preset(label: '45s', seconds: 45),
    _Preset(label: '60s', seconds: 60),
    _Preset(label: '90s', seconds: 90),
    _Preset(label: '2min', seconds: 120),
    _Preset(label: '3min', seconds: 180),
  ];

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: timerService,
      builder: (context, _) {
        final finished = timerService.isFinished;
        final running = timerService.isRunning;
        final progress = timerService.progress;

        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: cs.border, width: 0.5),
          ),
          padding: EdgeInsets.fromLTRB(r.lg, r.md, r.lg, r.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
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

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REST TIMER',
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(11),
                          color: kLime,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        finished ? "TIME'S UP!" : 'TAKE A BREATHER',
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(22),
                          fontWeight: FontWeight.w700,
                          color: finished ? kLime : cs.textPri,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      timerService.reset();
                      onDismiss();
                    },
                    child: Container(
                      width: r.sp(32),
                      height: r.sp(32),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.card,
                        border: Border.all(color: cs.border2, width: 0.5),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: r.sp(16),
                        color: cs.textMuted,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: r.xl),

              // Circular progress + timer
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: r.w(52),
                    height: r.w(52),
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3,
                      backgroundColor: cs.border2,
                      valueColor: AlwaysStoppedAnimation(
                        finished ? kSuccess : kLime,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        timerService.display,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: r.sp(48),
                          fontWeight: FontWeight.bold,
                          color: finished ? kLime : cs.textPri,
                          height: 1,
                        ),
                      ),
                      Text(
                        running
                            ? 'RESTING'
                            : finished
                            ? 'DONE'
                            : 'PAUSED',
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(11),
                          color: cs.textMuted,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: r.xl),

              // Preset chips
              Text(
                'QUICK SELECT',
                style: GoogleFonts.rajdhani(
                  fontSize: r.sp(10),
                  color: cs.textMuted,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: r.sm),
              Wrap(
                spacing: r.sm,
                runSpacing: r.sm,
                alignment: WrapAlignment.center,
                children: _presets.map((p) {
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      timerService.start(p.seconds);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.md,
                        vertical: r.sm,
                      ),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: cs.border2, width: 0.5),
                      ),
                      child: Text(
                        p.label,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: r.sp(12),
                          color: cs.textSec,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: r.lg),

              // Pause/Resume + Skip
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        running ? timerService.pause() : timerService.resume();
                      },
                      child: Container(
                        height: r.h(7).clamp(50.0, 60.0),
                        decoration: BoxDecoration(
                          color: cs.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: cs.border2, width: 0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              running
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: cs.textPri,
                              size: r.sp(20),
                            ),
                            SizedBox(width: r.xs),
                            Text(
                              running ? 'PAUSE' : 'RESUME',
                              style: GoogleFonts.rajdhani(
                                fontSize: r.sp(14),
                                color: cs.textPri,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: r.sm),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      timerService.skip();
                      onDismiss();
                    },
                    child: Container(
                      height: r.h(7).clamp(50.0, 60.0),
                      padding: EdgeInsets.symmetric(horizontal: r.lg),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.border2, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.skip_next_rounded,
                            color: cs.textMuted,
                            size: r.sp(18),
                          ),
                          SizedBox(width: r.xs),
                          Text(
                            'SKIP',
                            style: GoogleFonts.rajdhani(
                              fontSize: r.sp(14),
                              color: cs.textMuted,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Preset {
  final String label;
  final int seconds;
  const _Preset({required this.label, required this.seconds});
}
