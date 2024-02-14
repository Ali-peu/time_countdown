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

class TimerGetNewDateTimeForEnd extends TimerEvent {
  final DateTime newDatetime;
  final DateTime stopTime;
  final DateTime now;

  const TimerGetNewDateTimeForEnd(
      {required this.newDatetime, required this.stopTime, required this.now});
}

class TimerGetNewTimes extends TimerEvent {
  final DateTime newDatetime;
  final DateTime stopTime;
  final DateTime now;

  const TimerGetNewTimes(
      {required this.newDatetime, required this.stopTime, required this.now});
}

class TimerStop extends TimerEvent {}

class TimerError extends TimerEvent {}

class TimerEdit extends TimerEvent {
  final DateTime editStartTime;
  final Duration durationAfterStart;

  const TimerEdit(
      {required this.editStartTime, required this.durationAfterStart});
}
