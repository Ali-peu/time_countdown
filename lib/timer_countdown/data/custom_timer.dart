import 'dart:async';

class TimerService {
  final _timerController = StreamController<Duration>();
  DateTime? _startTime;
  Timer? _timer;

  Stream<Duration> get timerStream => _timerController.stream;

  void startTimer(DateTime startTime) {
    _startTime = startTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        final now = DateTime.now();
        final difference = now.difference(_startTime!);
        _timerController.add(difference);
      }
    });
  }

  void updateStartTime(DateTime newStartTime) {
    if (newStartTime.isBefore(DateTime.now())) {
      if (_startTime != null) {
        final elapsedTime = _startTime!.difference(DateTime.now());
        _startTime = newStartTime.add(elapsedTime);
      } else {
        _startTime = newStartTime;
      }
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }

  bool isClose() {
    if (_timerController.isClosed) {
      return true;
    } else {
      return false;
    }
    
  }

  void dispose() {
    _timerController.close();
  }
}
