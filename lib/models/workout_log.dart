class WorkoutLog {
  final DateTime date;
  final String dayName;
  final int exerciseCount;
  final int completedCount;

  WorkoutLog({
    required this.date,
    required this.dayName,
    required this.exerciseCount,
    required this.completedCount,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'dayName': dayName,
    'exerciseCount': exerciseCount,
    'completedCount': completedCount,
  };

  factory WorkoutLog.fromJson(Map<String, dynamic> json) => WorkoutLog(
    date: DateTime.parse(json['date']),
    dayName: json['dayName'] ?? '',
    exerciseCount: json['exerciseCount'] ?? 0,
    completedCount: json['completedCount'] ?? 0,
  );
}
