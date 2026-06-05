import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerService extends ChangeNotifier {
  Timer? _timer;

  int _secondsRemaining = 0;
  int _totalSeconds = 0;
  bool _isRunning = false;
  bool _isFinished = false;

  int get secondsRemaining => _secondsRemaining;
  int get totalSeconds => _totalSeconds;
  bool get isRunning => _isRunning;
  bool get isFinished => _isFinished;

  double get progress =>
      _totalSeconds == 0 ? 0 : _secondsRemaining / _totalSeconds;

  String get display {
    final m = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void start(int seconds) {
    _cancel();
    _secondsRemaining = seconds;
    _totalSeconds = seconds;
    _isRunning = true;
    _isFinished = false;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining <= 0) {
        _isRunning = false;
        _isFinished = true;
        _cancel();
        notifyListeners();
        return;
      }
      _secondsRemaining--;
      notifyListeners();
    });
  }

  void pause() {
    _cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resume() {
    if (_secondsRemaining <= 0 || _isRunning) return;
    _isRunning = true;
    _isFinished = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining <= 0) {
        _isRunning = false;
        _isFinished = true;
        _cancel();
        notifyListeners();
        return;
      }
      _secondsRemaining--;
      notifyListeners();
    });
    notifyListeners();
  }

  void skip() {
    _cancel();
    _secondsRemaining = 0;
    _isRunning = false;
    _isFinished = true;
    notifyListeners();
  }

  void reset() {
    _cancel();
    _secondsRemaining = 0;
    _totalSeconds = 0;
    _isRunning = false;
    _isFinished = false;
    notifyListeners();
  }

  void _cancel() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }
}
