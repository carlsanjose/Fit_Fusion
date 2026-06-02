import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive.dart';
import '../models/exercise.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Dismissible(
      key: Key(exercise.name + exercise.hashCode.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onDelete();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: r.lg),
        margin: EdgeInsets.only(bottom: r.sm),
        decoration: BoxDecoration(
          color: kDanger,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: r.sp(22),
            ),
            SizedBox(height: r.xs / 2),
            Text(
              'DELETE',
              style: GoogleFonts.rajdhani(
                fontSize: r.sp(10),
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onEdit();
        },
        child: Container(
          margin: EdgeInsets.only(bottom: r.sm),
          padding: EdgeInsets.all(r.md),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kBorder, width: 0.5),
          ),
          child: Row(
            children: [
              // Left: name + detail
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: GoogleFonts.dmSans(
                        fontSize: r.sp(15),
                        fontWeight: FontWeight.w600,
                        color: kTextPri,
                      ),
                    ),
                    SizedBox(height: r.xs),
                    Row(
                      children: [
                        _pill(r, '${exercise.sets} sets'),
                        SizedBox(width: r.xs),
                        _pill(r, '${exercise.reps} reps'),
                      ],
                    ),
                  ],
                ),
              ),

              // Right: weight + edit hint
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    exercise.weight % 1 == 0
                        ? '${exercise.weight.toInt()}'
                        : '${exercise.weight}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: r.sp(24),
                      color: kLime,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  Text(
                    'KG',
                    style: TextStyle(color: kTextMuted, fontSize: r.sp(10)),
                  ),
                  SizedBox(height: r.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: r.sp(11),
                        color: kTextMuted,
                      ),
                      SizedBox(width: 2),
                      Text(
                        'tap to edit',
                        style: TextStyle(fontSize: r.sp(10), color: kTextMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(Responsive r, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.sm, vertical: r.xs / 2),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: kBorder2, width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: r.sp(11), color: kTextSec),
      ),
    );
  }
}
