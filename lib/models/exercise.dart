class Exercise {
  String name;
  int sets;
  int reps;
  double weight;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'sets': sets,
    'reps': reps,
    'weight': weight,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    name: json['name'],
    sets: json['sets'],
    reps: json['reps'],
    weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
  );
}
