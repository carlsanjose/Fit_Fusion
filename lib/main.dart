import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const WorkoutShufflerApp());
}

class WorkoutShufflerApp extends StatelessWidget {
  const WorkoutShufflerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Shuffler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WorkoutHomeScreen(),
    );
  }
}

// --- MODELS ---

class Exercise {
  String name;
  int sets;
  int reps;
  double weight; // Replaced history list with a single target weight

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

class ActiveExercise {
  Exercise exercise;
  bool isDone;
  TextEditingController weightController;

  ActiveExercise({
    required this.exercise,
    this.isDone = false,
    String? currentSessionWeight,
  }) : weightController = TextEditingController(
          // Pre-populate with session weight if it exists, otherwise use the database weight
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

// --- MAIN SCREEN ---

class WorkoutHomeScreen extends StatefulWidget {
  const WorkoutHomeScreen({super.key});

  @override
  State<WorkoutHomeScreen> createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen> {
  List<Exercise> savedExercises = [];
  List<ActiveExercise> currentSession = [];

  // Controllers for adding a new exercise
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    for (var active in currentSession) {
      active.weightController.dispose();
    }
    super.dispose();
  }

  // --- LOCAL STORAGE LOGIC ---

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Database
    final String? exercisesJson = prefs.getString('saved_exercises');
    if (exercisesJson != null) {
      final List<dynamic> decodedList = jsonDecode(exercisesJson);
      setState(() {
        savedExercises = decodedList.map((e) => Exercise.fromJson(e)).toList();
      });
    }

    // Load Session
    final String? sessionJson = prefs.getString('current_session');
    if (sessionJson != null) {
      final List<dynamic> decodedList = jsonDecode(sessionJson);
      setState(() {
        currentSession = decodedList.map((e) => ActiveExercise.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(savedExercises.map((e) => e.toJson()).toList());
    await prefs.setString('saved_exercises', encodedList);
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(currentSession.map((e) => e.toJson()).toList());
    await prefs.setString('current_session', encodedList);
  }

  // --- APP LOGIC ---

  void _addExercise() {
    if (_nameController.text.isEmpty ||
        _setsController.text.isEmpty ||
        _repsController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() {
      savedExercises.add(Exercise(
        name: _nameController.text.trim(),
        sets: int.tryParse(_setsController.text.trim()) ?? 0,
        reps: int.tryParse(_repsController.text.trim()) ?? 0,
        weight: double.tryParse(_weightController.text.trim()) ?? 0.0,
      ));
      _nameController.clear();
      _setsController.clear();
      _repsController.clear();
      _weightController.clear();
    });
    _saveExercises();
  }

  void _deleteExercise(int index) {
    setState(() {
      savedExercises.removeAt(index);
    });
    _saveExercises();
  }

  void _editDatabaseWeight(int index) {
    final exercise = savedExercises[index];
    final TextEditingController editController = 
        TextEditingController(text: exercise.weight.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${exercise.name} Weight'),
          content: TextField(
            controller: editController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'New Weight (KG)'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final double? parsed = double.tryParse(editController.text);
                if (parsed != null) {
                  setState(() {
                    exercise.weight = parsed;
                  });
                  _saveExercises();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _shuffleRoutine() {
    if (savedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No exercises to shuffle! Add some first.')));
      return;
    }

    setState(() {
      for (var active in currentSession) {
        active.weightController.dispose();
      }

      currentSession = savedExercises.map((e) => ActiveExercise(exercise: e)).toList();
      currentSession.shuffle();
    });
    
    _saveSession(); 
  }

  // --- UI BUILDERS ---

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workout Shuffler'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Database'),
              Tab(icon: Icon(Icons.fitness_center), text: 'Session'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDatabaseTab(),
            _buildSessionTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatabaseTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Inputs
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Exercise Name (e.g., Bench Press)'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _setsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Sets'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _repsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Reps'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: 'Weight (KG)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _addExercise,
                    icon: const Icon(Icons.add),
                    label: const Text('Save Exercise'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // List
          Expanded(
            child: ListView.builder(
              itemCount: savedExercises.length,
              itemBuilder: (context, index) {
                final exercise = savedExercises[index];
                return Card(
                  child: ListTile(
                    title: Text(exercise.name),
                    subtitle: Text('${exercise.sets} Sets x ${exercise.reps} Reps  |  ${exercise.weight} KG'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editDatabaseWeight(index), // Edit button
                          tooltip: 'Edit Base Weight',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteExercise(index),
                          tooltip: 'Delete Exercise',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              onPressed: _shuffleRoutine,
              icon: const Icon(Icons.shuffle),
              label: const Text('Shuffle / Reshuffle Workout',
                  style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: currentSession.isEmpty
                ? const Center(child: Text('Press shuffle to generate your routine!'))
                : ListView.builder(
                    itemCount: currentSession.length,
                    itemBuilder: (context, index) {
                      final activeEx = currentSession[index];

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: activeEx.isDone,
                            onChanged: (bool? value) {
                              setState(() {
                                activeEx.isDone = value ?? false;
                              });
                              _saveSession(); 
                            },
                          ),
                          title: Text(
                            activeEx.exercise.name,
                            style: TextStyle(
                              decoration: activeEx.isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          // The target weight is displayed dynamically here alongside sets/reps
                          subtitle: Text(
                              '${activeEx.exercise.sets} Sets x ${activeEx.exercise.reps} Reps  |  Target: ${activeEx.exercise.weight} KG'),
                          trailing: SizedBox(
                            width: 80,
                            child: TextField(
                              controller: activeEx.weightController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) => _saveSession(),
                              decoration: const InputDecoration(
                                labelText: 'Actual',
                                suffixText: 'kg',
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}