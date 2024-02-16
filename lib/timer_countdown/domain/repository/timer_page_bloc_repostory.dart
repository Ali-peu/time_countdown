import 'dart:async';

import 'package:time_countdown/timer_countdown/domain/models/timer_state_model.dart';

class TimerPageBlocRepostory {
  final _timerPageEventsController = StreamController<TimerStateModel>();

  Stream<TimerStateModel> get timerPageStream =>
      _timerPageEventsController.stream;

  Future<void> dispose() async {
    await _timerPageEventsController.close();
  }

  Future<void> addElement(TimerStateModel timerStateModel) async {
    _timerPageEventsController.add(timerStateModel);
  }
}
