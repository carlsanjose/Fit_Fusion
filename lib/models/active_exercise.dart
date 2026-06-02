import 'package:flutter/material.dart';
import 'exercise.dart';

class ActiveExercise {
  Exercise exercise;
  bool isDone;
  TextEditingController weightController;

  ActiveExercise({
    required this.exercise,
    this.isDone = false,
    String? currentSessionWeight,
  }) : weightController = TextEditingController(
         text: currentSessionWeight ?? exercise.weight.toString(),
       );

  Map<String, dynamic> toJson() => {
    'exercise': exercise.toJson(),
    'isDone': isDone,
    'currentWeight': weightController.text,
  };

  factory ActiveExercise.fromJson(Map<String, dynamic> json) => ActiveExercise(
    exercise: Exercise.fromJson(json['exercise']),
    isDone: json['isDone'] ?? false,
    currentSessionWeight: json['currentWeight'],
  );
}
