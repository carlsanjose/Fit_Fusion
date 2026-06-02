import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';
import '../models/active_exercise.dart';

class StorageService {
  static const _exercisesKey = 'saved_exercises';
  static const _sessionKey = 'current_session';

  Future<List<Exercise>> loadExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_exercisesKey);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((e) => Exercise.fromJson(e)).toList();
  }

  Future<void> saveExercises(List<Exercise> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _exercisesKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  Future<List<ActiveExercise>> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((e) => ActiveExercise.fromJson(e)).toList();
  }

  Future<void> saveSession(List<ActiveExercise> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _sessionKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }
}
