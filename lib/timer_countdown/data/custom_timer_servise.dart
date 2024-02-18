import 'dart:async';
import 'dart:developer';

enum TimerServiseStatus { start, stop }

class TimerService {
  final _timerController = StreamController<Duration>();
  DateTime? _startTime;
  Timer? _timer;
  bool isStart = true;

  Stream<Duration> get timerStream => _timerController.stream;

  Future<void> startTimer(DateTime startTime) async {
    if (isStart) {
      log('isStart true');
      _startTime = startTime;
    } else {
      log('isStart false, следовательно в _startTime время откатанное в назад от now в разницу время пробуждение и когда он уснул');
    }

    log(_timer.toString(), name: '_timerToString ');
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        final now = DateTime.now();
        final difference = now.difference(_startTime!);
        _timerController.add(difference);
      }
    });
  }

  Future<void> updateStartTime(DateTime newStartTime, DateTime stopTime,
      TimerServiseStatus startOrStop) async {
    if (newStartTime.isBefore(DateTime.now())) {
      if (_startTime != null) {
        isStart = true;

        if (startOrStop == TimerServiseStatus.start) {
          final elapsedTime = _startTime!.difference(stopTime);
          _startTime = newStartTime.add(elapsedTime);
        } else {
          final difference = stopTime.difference(newStartTime);
          _startTime = DateTime.now().subtract(difference);
          isStart = false;
        }
      } else {
        _startTime = newStartTime;
      }
    }
  }

  Future<void> stopTimer() async {
    _timer?.cancel();
  }

  bool isClose() {
    if (_timerController.isClosed) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> dispose() async {
    await stopTimer();
    await _timerController.close();
  }
}
