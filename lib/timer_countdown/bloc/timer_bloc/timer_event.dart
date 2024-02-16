part of 'timer_bloc.dart';

sealed class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class FetchedChildrens extends TimerEvent {}

class TimerStart extends TimerEvent {
  final DateTime startDateTime;
  const TimerStart({required this.startDateTime});
}

class GetPickedChildId extends TimerEvent {
  final int pickedBabyId;

  const GetPickedChildId({required this.pickedBabyId});
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

class FetchedListChildSleepTimeStats extends TimerEvent {}

class TimerStop extends TimerEvent {
  final DateTime dateTime;
  final int babyID;

  const TimerStop({required this.dateTime, required this.babyID});
}

class TimerError extends TimerEvent {}

class UpdateDefautlState extends TimerEvent {
  final DateTime stopTime;

  const UpdateDefautlState({required this.stopTime});
}
