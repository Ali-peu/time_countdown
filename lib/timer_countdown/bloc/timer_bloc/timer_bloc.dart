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

  Future<void> _timerGetNewDateTimeForEnd(
      TimerGetNewDateTimeForEnd event) async {
    if (!event.stopTime.isAfter(unredactedStartTime!) ||
        event.stopTime.isAfter(event.now)) {
      add(TimerError());
    } else {
      setUnredactedStopTime(event.stopTime);
      timerService.updateStartTime(event.newDatetime, event.stopTime, 'Stop');
      add(TimerStart(startDateTime: unredactedStartTime!));
    }
  }

  Future<void> _timerGetNewTimesOrRedected(TimerGetNewTimes event) async {
    if (unredactedStartTime == null) {
      add(TimerStart(startDateTime: event.newDatetime));
    } else {
      if (event.newDatetime.isBefore(event.now) &&
          event.newDatetime.isBefore(event.stopTime)) {
        timerService.updateStartTime(
            event.newDatetime, event.stopTime, 'Start');
        setUnredactedStartTime(event.newDatetime);

        add(TimerStart(startDateTime: unredactedStartTime!));
      } else {
        add(TimerError());
      }
    }
  }

  Future<void> timerError(Emitter<TimerState> emit) async {
    emit(const TimerState(timerStatus: TimerStatus.initial, result: 'error'));
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
    timerService.stopTimer();
    timerService.dispose();
    setUnredactedStopTime(event.dateTime);
    emit(const TimerState(timerStatus: TimerStatus.stop));
    return;
  }
}
