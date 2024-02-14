import 'dart:async';

class TimerService {
  final _timerController = StreamController<Duration>();
  DateTime? _startTime;
  Timer? _timer;
  bool isStart = true;

  Stream<Duration> get timerStream => _timerController.stream;

  void startTimer(DateTime startTime) {
    if (isStart) {
      _startTime = startTime;
    } else {}

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        final now = DateTime.now();
        final difference = now.difference(_startTime!);
        _timerController.add(difference);
      }
    });
  }

  void updateStartTime(
      DateTime newStartTime, DateTime stopTime, String startOrStop) {
    if (newStartTime.isBefore(DateTime.now())) {
      if (_startTime != null) {
        isStart = true;

        if (startOrStop == 'Start') {
          final elapsedTime = _startTime!.difference(stopTime);

          _startTime = newStartTime.add(elapsedTime);
        } else {
          Duration difference = stopTime.difference(newStartTime);
          _startTime = DateTime.now().subtract(difference);
          isStart = false;
        }
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
