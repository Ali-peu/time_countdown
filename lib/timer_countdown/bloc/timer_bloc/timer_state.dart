part of 'timer_bloc.dart';

enum TimerStatus { initial, play, pause, stop }

class TimerState extends Equatable {
  const TimerState(
      {this.timerStatus = TimerStatus.initial, this.timer = const Duration()});
  final TimerStatus timerStatus;
  final Duration timer;

  @override
  List<Object> get props => [timerStatus, timer];
}
