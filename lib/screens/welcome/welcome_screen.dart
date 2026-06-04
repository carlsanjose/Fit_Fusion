import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _pulseAnim;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleStart() async {
    setState(() => _loading = true);
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_welcome', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.bg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: r.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.h(8)),

                  // Top badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.md,
                      vertical: r.xs,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: cs.border2, width: 0.5),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: cs.lime,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: r.xs),
                        Text(
                          'FIT FUSION',
                          style: GoogleFonts.rajdhani(
                            fontSize: r.sp(11),
                            color: cs.textSec,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: r.h(5)),

                  // Hero heading
                  Text(
                    'BUILT\nTO LIFT.',
                    style: GoogleFonts.rajdhani(
                      fontSize: r.sp(64),
                      fontWeight: FontWeight.w700,
                      color: cs.textPri,
                      height: 0.9,
                      letterSpacing: -1,
                    ),
                  ),

                  SizedBox(height: r.lg),

                  // Accent line
                  Container(width: r.w(15), height: 2, color: cs.lime),

                  SizedBox(height: r.lg),

                  // Subtitle
                  Text(
                    'Track your exercises, shuffle\nyour routine, and push further\nevery session.',
                    style: GoogleFonts.dmSans(
                      fontSize: r.sp(16),
                      color: cs.textSec,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: r.h(5)),

                  // Feature pills row
                  Wrap(
                    spacing: r.sm,
                    runSpacing: r.sm,
                    children: [
                      _featurePill(
                        r,
                        cs,
                        Icons.shuffle_rounded,
                        'Smart Shuffle',
                      ),
                      _featurePill(
                        r,
                        cs,
                        Icons.fitness_center_rounded,
                        'Weight Tracking',
                      ),
                      _featurePill(
                        r,
                        cs,
                        Icons.check_circle_outline_rounded,
                        'Session Progress',
                      ),
                    ],
                  ),

                  const Spacer(),

                  // CTA button
                  ScaleTransition(
                    scale: _pulseAnim,
                    child: GestureDetector(
                      onTap: _loading ? null : _handleStart,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        height: r.h(8).clamp(56.0, 72.0),
                        decoration: BoxDecoration(
                          color: _loading ? cs.border2 : cs.lime,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: _loading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: cs.textMuted,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'GET STARTED',
                                      style: GoogleFonts.rajdhani(
                                        fontSize: r.sp(17),
                                        fontWeight: FontWeight.w700,
                                        color: cs.onPrimary,
                                        letterSpacing: 2.5,
                                      ),
                                    ),
                                    SizedBox(width: r.sm),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: cs.onPrimary,
                                      size: r.sp(18),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: r.sm),

                  // Fine print
                  Center(
                    child: Text(
                      'Your data stays on your device',
                      style: TextStyle(fontSize: r.sp(12), color: cs.textMuted),
                    ),
                  ),

                  SizedBox(height: r.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _featurePill(
    Responsive r,
    ColorScheme cs,
    IconData icon,
    String label,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.md, vertical: r.xs + 2),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: cs.border2, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: r.sp(13), color: cs.lime),
          SizedBox(width: r.xs),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: r.sp(12),
              color: cs.textSec,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
