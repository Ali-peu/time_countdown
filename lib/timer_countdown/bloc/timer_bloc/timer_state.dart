part of 'timer_bloc.dart';

enum TimerStatus { initial, play, pause, stop,wasChange }

class TimerState extends Equatable {
  const TimerState(
      {this.timerStatus = TimerStatus.initial});
  final TimerStatus timerStatus;
 

  @override
  List<Object> get props => [timerStatus];
}
