class Exercise {
  String name;
  int sets;
  int reps;
  double weight;
  String muscleGroup;
  String notes;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    this.muscleGroup = '',
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'sets': sets,
    'reps': reps,
    'weight': weight,
    'muscleGroup': muscleGroup,
    'notes': notes,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    name: json['name'],
    sets: json['sets'],
    reps: json['reps'],
    weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
    muscleGroup: json['muscleGroup'] ?? '',
    notes: json['notes'] ?? '',
  );
}
