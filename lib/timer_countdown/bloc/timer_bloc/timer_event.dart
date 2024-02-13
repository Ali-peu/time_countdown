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

  const TimerGetNewTimes({required this.newDatetime});

}

class TimerStop extends TimerEvent {}

class TimerEditPageOpen extends TimerEvent {}

class TimerEdit extends TimerEvent {
  final DateTime editStartTime;
  final Duration durationAfterStart;

  const TimerEdit(
      {required this.editStartTime, required this.durationAfterStart});
}
