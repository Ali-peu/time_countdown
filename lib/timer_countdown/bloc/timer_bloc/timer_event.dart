part of 'timer_bloc.dart';

sealed class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStart extends TimerEvent {
  final DateTime startDateTime;
  const TimerStart({required this.startDateTime});
}

class TimerGetNewTimes extends TimerEvent {
  final DateTime newDatetime;
  final DateTime stopTime;
  final String startOrStop;
  const TimerGetNewTimes( {required this.startOrStop,required this.newDatetime, required this.stopTime});
}

class TimerStopTimeSave extends TimerEvent {
  final DateTime stopTime;

  const TimerStopTimeSave({required this.stopTime});
}

class TimerStop extends TimerEvent {}

class TimerError extends TimerEvent {}

class TimerEdit extends TimerEvent {
  final DateTime editStartTime;
  final Duration durationAfterStart;

  const TimerEdit(
      {required this.editStartTime, required this.durationAfterStart});
}
