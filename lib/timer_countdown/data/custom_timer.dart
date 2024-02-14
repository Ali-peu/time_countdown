import 'dart:async';
import 'dart:developer';

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
    log('Это сама TimerService вызывает');
    log(stopTime.toString(), name: 'Это его stopTime');
    log(newStartTime.toString(), name: 'Это его newStartTime');

    if (newStartTime.isBefore(DateTime.now())) {
      log(newStartTime.isBefore(DateTime.now()).toString(),
          name:
              'Проверка условии из самой TimerServise,newStartTime.isBefore(DateTime.now()).toString()');
      if (_startTime != null) {
        isStart = true;
        bool a = _startTime != null;
        log(a.toString(),
            name: 'Проверка условии из самой TimerServise _startTime != null');
        if (startOrStop == 'Start') {
          final elapsedTime = _startTime!.difference(stopTime);
          log(elapsedTime.toString(), name: 'TimerServise elapsedTime');
          _startTime = newStartTime.add(elapsedTime);
        } else {
          // final elapsedTime = stopTime.difference(_startTime!);
          log(stopTime.toString(),
              name: 'TimerServise устанвиливает конец промежуток');
          Duration difference = stopTime.difference(newStartTime);
          log(difference.inHours.toString(),
              name: 'TimerServise устанвиливает конец промежуток разнца');
          _startTime = DateTime.now().subtract(difference);
          isStart = false;
          log(_startTime.toString(),
              name:
                  'Новый таймер TimerServise когда конец промежутка изменилась');
        }
      } else {
        log(' _startTime == null',
            name: 'Проверка условии из самой TimerServise _startTime == null');
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
