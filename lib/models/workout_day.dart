class WorkoutDay {
  String id;
  String name; // e.g. "Push Day", "Pull Day", "Legs"
  String description; // e.g. "Chest, Shoulders, Triceps"
  List<String> exerciseNames; // ordered list of exercise names

  WorkoutDay({
    required this.id,
    required this.name,
    required this.description,
    required this.exerciseNames,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'exerciseNames': exerciseNames,
  };

  factory WorkoutDay.fromJson(Map<String, dynamic> json) => WorkoutDay(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    exerciseNames: List<String>.from(json['exerciseNames'] ?? []),
  );
}
