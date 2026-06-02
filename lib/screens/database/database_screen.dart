import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../models/exercise.dart';
import '../../widgets/exercise_card.dart';

class DatabaseScreen extends StatelessWidget {
  final List<Exercise> exercises;
  final TextEditingController nameController;
  final TextEditingController setsController;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final VoidCallback onAdd;
  final void Function(int index) onDelete;
  final void Function(int index) onEdit;

  const DatabaseScreen({
    super.key,
    required this.exercises,
    required this.nameController,
    required this.setsController,
    required this.repsController,
    required this.weightController,
    required this.onAdd,
    required this.onDelete,
    required this.onEdit,
  });

  void _showAddSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _AddExerciseSheet(
          nameController: nameController,
          setsController: setsController,
          repsController: repsController,
          weightController: weightController,
          onAdd: () {
            onAdd();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: kBg,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kLime,
        foregroundColor: kBg,
        elevation: 0,
        onPressed: () => _showAddSheet(context),
        child: Icon(Icons.add_rounded, size: r.sp(24)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(r.lg, r.lg, r.lg, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LIBRARY',
                    style: GoogleFonts.rajdhani(
                      fontSize: r.sp(11),
                      color: kLime,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: r.xs / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'EXERCISES',
                        style: GoogleFonts.rajdhani(
                          fontSize: r.sp(36),
                          fontWeight: FontWeight.w700,
                          color: kTextPri,
                          height: 1,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (exercises.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: r.sm,
                            vertical: r.xs,
                          ),
                          decoration: BoxDecoration(
                            color: kCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kBorder2, width: 0.5),
                          ),
                          child: Text(
                            '${exercises.length}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: r.sp(13),
                              color: kLime,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: r.md),
                  Container(height: 0.5, color: kBorder),
                ],
              ),
            ),

            SizedBox(height: r.md),

            // List
            Expanded(
              child: exercises.isEmpty
                  ? _buildEmptyState(r)
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: r.md),
                      itemCount: exercises.length,
                      itemBuilder: (_, i) => ExerciseCard(
                        exercise: exercises[i],
                        onEdit: () => onEdit(i),
                        onDelete: () => onDelete(i),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Responsive r) {
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
                color: kCard,
                border: Border.all(color: kBorder2, width: 0.5),
              ),
              child: Icon(
                Icons.fitness_center_rounded,
                size: r.sp(32),
                color: kTextMuted,
              ),
            ),
            SizedBox(height: r.lg),
            Text(
              'NO EXERCISES YET',
              style: GoogleFonts.rajdhani(
                fontSize: r.sp(16),
                color: kTextMuted,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: r.sm),
            Text(
              'Tap + to add your first exercise\nto the library',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: r.sp(13),
                color: kTextMuted,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddExerciseSheet extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController setsController;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final VoidCallback onAdd;

  const _AddExerciseSheet({
    required this.nameController,
    required this.setsController,
    required this.repsController,
    required this.weightController,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(r.lg, r.md, r.lg, r.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: r.w(10),
              height: 3,
              decoration: BoxDecoration(
                color: kBorder2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: r.lg),

          // Sheet header
          Text(
            'ADD EXERCISE',
            style: GoogleFonts.rajdhani(
              fontSize: r.sp(11),
              color: kLime,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: r.xs / 2),
          Text(
            'NEW ENTRY',
            style: GoogleFonts.rajdhani(
              fontSize: r.sp(28),
              fontWeight: FontWeight.w700,
              color: kTextPri,
              height: 1,
            ),
          ),
          SizedBox(height: r.lg),

          TextField(
            controller: nameController,
            style: GoogleFonts.dmSans(color: kTextPri, fontSize: r.sp(15)),
            decoration: InputDecoration(
              hintText: 'e.g. Bench Press',
              labelText: 'EXERCISE NAME',
              prefixIcon: Icon(
                Icons.fitness_center_rounded,
                size: r.sp(18),
                color: kTextMuted,
              ),
            ),
          ),
          SizedBox(height: r.sm),

          // Number fields with labels above
          Row(
            children: [
              Expanded(
                child: _labelledField(
                  r,
                  label: 'SETS',
                  controller: setsController,
                  hint: '3',
                ),
              ),
              SizedBox(width: r.sm),
              Expanded(
                child: _labelledField(
                  r,
                  label: 'REPS',
                  controller: repsController,
                  hint: '10',
                ),
              ),
              SizedBox(width: r.sm),
              Expanded(
                child: _labelledField(
                  r,
                  label: 'KG',
                  controller: weightController,
                  hint: '60',
                  decimal: true,
                ),
              ),
            ],
          ),

          SizedBox(height: r.xl),

          SizedBox(
            width: double.infinity,
            height: r.h(7).clamp(52.0, 64.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kLime,
                foregroundColor: kBg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onAdd,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, size: r.sp(18), color: kBg),
                  SizedBox(width: r.xs),
                  Text(
                    'SAVE TO LIBRARY',
                    style: GoogleFonts.rajdhani(
                      fontSize: r.sp(15),
                      fontWeight: FontWeight.w700,
                      color: kBg,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelledField(
    Responsive r, {
    required String label,
    required TextEditingController controller,
    required String hint,
    bool decimal = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: decimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      textAlign: TextAlign.center,
      style: GoogleFonts.jetBrainsMono(
        color: kTextPri,
        fontSize: r.sp(16),
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: kTextMuted, fontSize: r.sp(13)),
      ),
    );
  }
}
