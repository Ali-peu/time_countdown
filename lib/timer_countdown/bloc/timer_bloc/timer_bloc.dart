import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:time_countdown/timer_countdown/data/custom_timer.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  DateTime? unredactedStartTime;
  TimerService timerService = TimerService();
  TimerBloc() : super(const TimerState()) {
    on<TimerStart>((event, emit) => _onTimerPlay(event, emit));
    on<TimerStop>((event, emit) => _onTimerStop(event, emit));

    on<TimerGetNewTimes>((event, emit) {
      if (unredactedStartTime != null) {
        if (event.newDatetime.isAfter(unredactedStartTime!)) {}
        {
          timerService.updateStartTime(event.newDatetime);
          unredactedStartTime = event.newDatetime;
          add(TimerStart(startDateTime: unredactedStartTime!));
        }
      }
      timerService.updateStartTime(event.newDatetime);
    });
  }

  Future<void> _onTimerPlay(TimerStart event, Emitter<TimerState> emit) async {
    if (timerService.isClose()) {
      timerService = TimerService();
    }

    if (unredactedStartTime != null) {
      if (unredactedStartTime != event.startDateTime) {
        Duration duration =
            event.startDateTime.difference(unredactedStartTime!);
        log(_printDuration(duration), name: 'Duration TimerBLOC');
      }
    }
    log('IS IT LOGGED AFTER IF IF ', name: 'Conditions');

    unredactedStartTime = event.startDateTime;
    timerService.startTimer(event.startDateTime);

    emit(const TimerState(timerStatus: TimerStatus.play));
  }

  Future<void> _onTimerStop(TimerStop event, Emitter<TimerState> emit) async {
    timerService.dispose();
    timerService.stopTimer();
    unredactedStartTime = null;
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
