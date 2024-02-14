import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:time_countdown/timer_countdown/data/custom_timer.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  DateTime? _unredactedStartTime;

  DateTime? get unredactedStartTime => _unredactedStartTime;

  void setUnredactedStartTime(DateTime dateTime) {
    _unredactedStartTime = dateTime;
  }

  DateTime? _unredactedStopTime;

  DateTime? get unredactedStopTime => _unredactedStopTime;

  void setUnredactedStopTime(DateTime value) {
    _unredactedStopTime = value;
  }

  TimerService timerService = TimerService();

  TimerBloc() : super(const TimerState()) {
    on<TimerStart>((event, emit) => _onTimerPlay(event, emit));
    on<TimerStop>((event, emit) => _onTimerStop(event, emit));

    on<TimerGetNewTimes>((event, emit) => _timerGetNewTimesOrRedected(event));
    on<TimerError>((event, emit) => timerError(emit));

    on<TimerGetNewDateTimeForEnd>(
        (event, emit) => _timerGetNewDateTimeForEnd(event));
  }

  void _timerGetNewDateTimeForEnd(TimerGetNewDateTimeForEnd event) {
    setUnredactedStopTime(event.stopTime);
    timerService.updateStartTime(event.newDatetime, event.stopTime, 'Stop');
    add(TimerStart(startDateTime: unredactedStartTime!));
  }

  Future<void> _timerGetNewTimesOrRedected(TimerGetNewTimes event) async {
    DateTime now = DateTime.now();

    log(event.newDatetime.toString(), name: 'Event newDateTime');
    if (unredactedStartTime != null) {
      log(unredactedStartTime.toString(), name: 'Bloc unredactedStartTime');
    } else {
      log('NULL', name: 'Bloc unredactedStartTime null');
    }

    if (unredactedStartTime == null) {
      add(TimerStart(startDateTime: event.newDatetime));
    } else {
      if (event.newDatetime.isBefore(now)) {
        //TODO now получить со евента
        
      }

      if (event.startOrStop == 'Start') {
        timerService.updateStartTime(
            event.newDatetime, event.stopTime, 'Start');
      } else {
        setUnredactedStopTime(event.stopTime);
        log('IS It printed');
        timerService.updateStartTime(event.newDatetime, event.stopTime, 'Stop');
      }

      setUnredactedStartTime(event.newDatetime);

      add(TimerStart(startDateTime: unredactedStartTime!));
    }
  }

  Future<void> timerError(Emitter<TimerState> emit) async {
    if (timerService.isClose()) {
      emit(const TimerState(
          timerStatus: TimerStatus.initial,
          result: 'picked Timer isAfter(now)'));
    }
  }

  Future<void> _onTimerPlay(TimerStart event, Emitter<TimerState> emit) async {
    if (timerService.isClose()) {
      timerService = TimerService();
    }
    setUnredactedStartTime(event.startDateTime);

    timerService.startTimer(event.startDateTime);
    emit(const TimerState(timerStatus: TimerStatus.play, result: ''));
  }

  Future<void> _onTimerStop(TimerStop event, Emitter<TimerState> emit) async {
    timerService.dispose();
    timerService.stopTimer();
    // unredactedStartTime = null; TODO проверить нужен ли тут обнуление
    emit(const TimerState(timerStatus: TimerStatus.stop));
  }
}
