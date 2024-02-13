part of 'timer_bloc.dart';

sealed class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStart extends TimerEvent {
  final Duration duration;
  const TimerStart({required this.duration});
}

class TimerGetNewTimes extends TimerEvent {}

class TimerStop extends TimerEvent {}

class TimerPause extends TimerEvent {
  final Duration duration;
  const TimerPause({required this.duration});
}

class TimerUnPause extends TimerEvent {
  final Duration duration;
  const TimerUnPause({required this.duration});
}
