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

  set unredactedStartTime(DateTime? value) {
    _unredactedStartTime = value;
  }

  DateTime? unredactedStopTime;
  TimerService timerService = TimerService();
  TimerBloc() : super(const TimerState()) {
    on<TimerStart>((event, emit) => _onTimerPlay(event, emit));
    on<TimerStop>((event, emit) => _onTimerStop(event, emit));

    on<TimerGetNewTimes>((event, emit) {
      log(event.newDatetime.toString(), name: 'Event newDateTime');
      if (unredactedStartTime != null) {
        log(unredactedStartTime.toString(), name: 'Bloc unredactedStartTime');
      } else {
        log('NULL', name: 'Bloc unredactedStartTime null');
      }

      if (unredactedStartTime == null) {
        add(TimerStart(startDateTime: event.newDatetime));
      } else {
        if (event.startOrStop == 'Start') {
          timerService.updateStartTime(
              event.newDatetime, event.stopTime, 'Start');
        } else {
          timerService.updateStartTime(
              event.newDatetime, event.stopTime, 'Stop');
        }

        setUnredactedStartTime(event.newDatetime);

        add(TimerStart(startDateTime: unredactedStartTime!));
      }
    });
    on<TimerError>((event, emit) {
      if (timerService.isClose()) {
        emit(const TimerState(
            timerStatus: TimerStatus.initial,
            result: 'picked Timer isAfter(now)'));
        return;
      }
    });

    on<TimerStopTimeSave>((event, emit) {
      unredactedStopTime = event.stopTime;
    });
  }

  Future<void> _onTimerPlay(TimerStart event, Emitter<TimerState> emit) async {
    if (timerService.isClose()) {
      timerService = TimerService();
    }
    setUnredactedStartTime(event.startDateTime);

    if (unredactedStartTime != null) {
      log(unredactedStartTime.toString(),
          name: 'Bloc unredactedStartTime _onTimerPlay');
    } else {
      log('NULL', name: 'Bloc unredactedStartTime null _onTimerPlay');
    }

    timerService.startTimer(event.startDateTime);
    emit(const TimerState(timerStatus: TimerStatus.play, result: ''));
  }

  Future<void> _onTimerStop(TimerStop event, Emitter<TimerState> emit) async {
    timerService.dispose();
    timerService.stopTimer();
    // unredactedStartTime = null; TODO проверить нужен ли тут обнуление
    emit(const TimerState(timerStatus: TimerStatus.stop));
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
