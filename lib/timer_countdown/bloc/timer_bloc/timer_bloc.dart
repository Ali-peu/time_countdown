import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(const TimerState()) {
    on<TimerStart>((event, emit) => _onTimerPlay(event, emit));
    on<TimerStop>((event, emit) => _onTimerStop(event, emit));
    on<TimerPause>((event, emit) {
      log(event.duration.toString());
      emit(TimerState(timer: event.duration, timerStatus: TimerStatus.pause));
    });
    on<TimerUnPause>((event, emit) {
      emit(TimerState(timerStatus: TimerStatus.play, timer: event.duration));
    });
  }

  Future<void> _onTimerPlay(TimerStart event, Emitter<TimerState> emit) async {
    if (state.timerStatus == TimerStatus.pause) {
      add(TimerUnPause(duration: event.duration));
    }

    emit(TimerState(timerStatus: TimerStatus.play, timer: event.duration));
  }

  Future<void> _onTimerStop(TimerStop event, Emitter<TimerState> emit) async {
    emit(const TimerState(timerStatus: TimerStatus.stop, timer: Duration()));
  }
}
