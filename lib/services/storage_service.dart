import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';
import '../models/active_exercise.dart';
import '../models/workout_day.dart';
import '../models/workout_log.dart';

class StorageService {
  static const _exercisesKey = 'saved_exercises';
  static const _sessionKey = 'current_session';
  static const _workoutDaysKey = 'workout_days';
  static const _workoutLogKey = 'workout_log';

  // ── Exercises ──────────────────────────────────────────────────────────────

  Future<List<Exercise>> loadExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_exercisesKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).map((e) => Exercise.fromJson(e)).toList();
  }

  Future<void> saveExercises(List<Exercise> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _exercisesKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  // ── Session ────────────────────────────────────────────────────────────────

  Future<List<ActiveExercise>> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => ActiveExercise.fromJson(e))
        .toList();
  }

  Future<void> saveSession(List<ActiveExercise> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _sessionKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  // ── Workout Days ───────────────────────────────────────────────────────────

  Future<List<WorkoutDay>> loadWorkoutDays() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_workoutDaysKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => WorkoutDay.fromJson(e))
        .toList();
  }

  Future<void> saveWorkoutDays(List<WorkoutDay> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _workoutDaysKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  // ── Workout Log (activity heatmap data) ───────────────────────────────────

  Future<List<WorkoutLog>> loadWorkoutLog() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_workoutLogKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => WorkoutLog.fromJson(e))
        .toList();
  }

  Future<void> saveWorkoutLog(List<WorkoutLog> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _workoutLogKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> appendWorkoutLog(WorkoutLog log) async {
    final list = await loadWorkoutLog();
    list.add(log);
    await saveWorkoutLog(list);
  }
}
