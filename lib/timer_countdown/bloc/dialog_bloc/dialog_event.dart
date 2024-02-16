part of 'dialog_bloc.dart';

sealed class DialogEvent extends Equatable {
  const DialogEvent();

  @override
  List<Object> get props => [];
}

class TimerGetNewDateTimeForEnd extends DialogEvent {
  final DateTime newDatetime;
  final DateTime stopTime;
  final DateTime now;

  const TimerGetNewDateTimeForEnd(
      {required this.newDatetime, required this.stopTime, required this.now});
}

class TimerGetNewTimes extends DialogEvent {
  final DateTime newDatetime;
  final DateTime stopTime;
  final DateTime now;

  const TimerGetNewTimes(
      {required this.newDatetime, required this.stopTime, required this.now});
}

class TimerStop extends DialogEvent {
  final DateTime dateTime;
  final int babyID;

  const TimerStop({required this.dateTime, required this.babyID});
}

class TimerError extends DialogEvent {}

class TimerStart extends DialogEvent {
  final DateTime startDateTime;
  const TimerStart({required this.startDateTime});
}
