import '../models/exercise.dart';
import '../models/workout_day.dart';

class StarterTemplate {
  final String name;
  final String description;
  final String frequency;
  final String level;
  final List<Exercise> exercises;
  final List<WorkoutDay> workoutDays;

  const StarterTemplate({
    required this.name,
    required this.description,
    required this.frequency,
    required this.level,
    required this.exercises,
    required this.workoutDays,
  });
}

final List<StarterTemplate> starterTemplates = [
  StarterTemplate(
    name: 'Full Body 3×/Week',
    description:
        'Hit every major muscle group each session. '
        'Best for complete beginners — simple, balanced, effective.',
    frequency: '3× per week',
    level: 'Beginner',
    exercises: [
      Exercise(
        name: 'Barbell Squat',
        sets: 3,
        reps: 8,
        weight: 40,
        muscleGroup: 'Quads',
        notes:
            'Feet shoulder-width apart. Drive knees out. '
            'Keep chest up and core tight throughout.',
      ),
      Exercise(
        name: 'Deadlift',
        sets: 3,
        reps: 6,
        weight: 50,
        muscleGroup: 'Back',
        notes:
            'Hinge at hips, bar close to shins. '
            'Drive through heels. Keep back flat — do not round.',
      ),
      Exercise(
        name: 'Bench Press',
        sets: 3,
        reps: 8,
        weight: 40,
        muscleGroup: 'Chest',
        notes:
            'Feet flat on floor. Retract shoulder blades. '
            'Lower bar to lower chest, press in a slight arc.',
      ),
      Exercise(
        name: 'Overhead Press',
        sets: 3,
        reps: 8,
        weight: 25,
        muscleGroup: 'Shoulders',
        notes:
            'Brace core hard. Press bar directly overhead. '
            'Lock out elbows at top. Avoid leaning back.',
      ),
      Exercise(
        name: 'Barbell Row',
        sets: 3,
        reps: 8,
        weight: 35,
        muscleGroup: 'Back',
        notes:
            'Hinge forward 45°. Pull bar to lower ribcage. '
            'Squeeze shoulder blades together at the top.',
      ),
    ],
    workoutDays: [
      WorkoutDay(
        id: 'fullbody_day1',
        name: 'Full Body',
        description: 'Quads, Back, Chest, Shoulders',
        exerciseNames: [
          'Barbell Squat',
          'Deadlift',
          'Bench Press',
          'Overhead Press',
          'Barbell Row',
        ],
      ),
    ],
  ),

  StarterTemplate(
    name: 'Upper / Lower Split',
    description:
        'Alternate upper and lower body days. '
        'Train 4× per week with more volume per muscle group.',
    frequency: '4× per week',
    level: 'Beginner–Intermediate',
    exercises: [
      Exercise(
        name: 'Bench Press',
        sets: 4,
        reps: 8,
        weight: 40,
        muscleGroup: 'Chest',
        notes:
            'Control the descent (2 seconds down). '
            'Drive feet into floor for stability.',
      ),
      Exercise(
        name: 'Barbell Row',
        sets: 4,
        reps: 8,
        weight: 35,
        muscleGroup: 'Back',
        notes:
            'Pull elbows back, not out. '
            'Hold the contraction for 1 second at the top.',
      ),
      Exercise(
        name: 'Overhead Press',
        sets: 3,
        reps: 10,
        weight: 22.5,
        muscleGroup: 'Shoulders',
        notes:
            'Start bar at collarbone height. '
            'Tuck chin as bar passes face.',
      ),
      Exercise(
        name: 'Barbell Curl',
        sets: 3,
        reps: 12,
        weight: 15,
        muscleGroup: 'Biceps',
        notes:
            'Keep elbows pinned to sides. '
            'Full range of motion — fully extend at bottom.',
      ),
      Exercise(
        name: 'Tricep Pushdown',
        sets: 3,
        reps: 12,
        weight: 20,
        muscleGroup: 'Triceps',
        notes:
            'Lock elbows at sides. '
            'Fully extend wrists down. Squeeze at bottom.',
      ),
      Exercise(
        name: 'Barbell Squat',
        sets: 4,
        reps: 8,
        weight: 40,
        muscleGroup: 'Quads',
        notes:
            'Break parallel if mobility allows. '
            'Push the floor away — do not think "pull up".',
      ),
      Exercise(
        name: 'Romanian Deadlift',
        sets: 3,
        reps: 10,
        weight: 40,
        muscleGroup: 'Hamstrings',
        notes:
            'Soft bend in knees. Push hips back, not down. '
            'Feel stretch in hamstrings before driving back up.',
      ),
      Exercise(
        name: 'Leg Press',
        sets: 3,
        reps: 12,
        weight: 80,
        muscleGroup: 'Quads',
        notes:
            'Feet shoulder-width, mid-platform. '
            'Do not lock knees at top. Control the descent.',
      ),
    ],
    workoutDays: [
      WorkoutDay(
        id: 'upperlower_upper',
        name: 'Upper Day',
        description: 'Chest, Back, Shoulders, Biceps, Triceps',
        exerciseNames: [
          'Bench Press',
          'Barbell Row',
          'Overhead Press',
          'Barbell Curl',
          'Tricep Pushdown',
        ],
      ),
      WorkoutDay(
        id: 'upperlower_lower',
        name: 'Lower Day',
        description: 'Quads, Hamstrings',
        exerciseNames: ['Barbell Squat', 'Romanian Deadlift', 'Leg Press'],
      ),
    ],
  ),

  StarterTemplate(
    name: 'Push / Pull / Legs',
    description:
        'Classic 3-day split. Push muscles one day, '
        'pull muscles next, legs after. Ideal for building size.',
    frequency: '3–6× per week',
    level: 'Intermediate',
    exercises: [
      Exercise(
        name: 'Bench Press',
        sets: 4,
        reps: 8,
        weight: 50,
        muscleGroup: 'Chest',
        notes:
            'Arch slightly, retract scapula. '
            'Touch chest lightly — do not bounce.',
      ),
      Exercise(
        name: 'Incline Dumbbell Press',
        sets: 3,
        reps: 10,
        weight: 20,
        muscleGroup: 'Chest',
        notes:
            'Set bench to 30–45°. '
            'Feel stretch at bottom, squeeze at top.',
      ),
      Exercise(
        name: 'Lateral Raise',
        sets: 3,
        reps: 15,
        weight: 8,
        muscleGroup: 'Shoulders',
        notes:
            'Slight forward lean. Lead with elbows, not wrists. '
            'Stop at shoulder height — no higher.',
      ),
      Exercise(
        name: 'Overhead Press',
        sets: 3,
        reps: 8,
        weight: 30,
        muscleGroup: 'Shoulders',
        notes: 'Full overhead lockout. Keep core braced throughout.',
      ),
      Exercise(
        name: 'Skull Crusher',
        sets: 3,
        reps: 12,
        weight: 20,
        muscleGroup: 'Triceps',
        notes:
            'Lower bar to forehead slowly. '
            'Keep upper arms perpendicular to floor.',
      ),
      Exercise(
        name: 'Deadlift',
        sets: 4,
        reps: 5,
        weight: 60,
        muscleGroup: 'Back',
        notes:
            'Setup: bar over mid-foot, hip-width stance. '
            'Take slack out of bar before pulling.',
      ),
      Exercise(
        name: 'Pull Up',
        sets: 3,
        reps: 6,
        weight: 0,
        muscleGroup: 'Back',
        notes:
            'Dead hang start. Pull chest to bar. '
            'If you cannot do 6, use an assisted machine.',
      ),
      Exercise(
        name: 'Face Pull',
        sets: 3,
        reps: 15,
        weight: 12,
        muscleGroup: 'Shoulders',
        notes:
            'Pull to nose height, elbows flared. '
            'Great for shoulder health — do not skip this.',
      ),
      Exercise(
        name: 'Barbell Squat',
        sets: 4,
        reps: 6,
        weight: 60,
        muscleGroup: 'Quads',
        notes:
            'Bar on upper traps. Big breath before descent. '
            'Drive knees out aggressively.',
      ),
      Exercise(
        name: 'Leg Curl',
        sets: 3,
        reps: 12,
        weight: 30,
        muscleGroup: 'Hamstrings',
        notes:
            'Full range. Control the negative (lowering) phase. '
            'Do not let hips rise off pad.',
      ),
      Exercise(
        name: 'Calf Raise',
        sets: 4,
        reps: 15,
        weight: 40,
        muscleGroup: 'Calves',
        notes:
            'Full stretch at bottom, full contraction at top. '
            'Pause 1 second at peak. Slow and controlled.',
      ),
    ],
    workoutDays: [
      WorkoutDay(
        id: 'ppl_push',
        name: 'Push Day',
        description: 'Chest, Shoulders, Triceps',
        exerciseNames: [
          'Bench Press',
          'Incline Dumbbell Press',
          'Lateral Raise',
          'Overhead Press',
          'Skull Crusher',
        ],
      ),
      WorkoutDay(
        id: 'ppl_pull',
        name: 'Pull Day',
        description: 'Back, Shoulders',
        exerciseNames: ['Deadlift', 'Pull Up', 'Face Pull'],
      ),
      WorkoutDay(
        id: 'ppl_legs',
        name: 'Legs Day',
        description: 'Quads, Hamstrings, Calves',
        exerciseNames: ['Barbell Squat', 'Leg Curl', 'Calf Raise'],
      ),
    ],
  ),
];
