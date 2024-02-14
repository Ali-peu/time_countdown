part of 'timer_bloc.dart';

enum TimerStatus { initial, play, pause, stop, wasChange }

class TimerState extends Equatable {
  const TimerState({
    this.timerStatus = TimerStatus.initial,
    this.result = '',
  });
  final TimerStatus timerStatus;
  final String result;

  TimerState copyWith({
    TimerStatus? timerStatus,
    String? result,
  }) {
    return TimerState(
      timerStatus: timerStatus = timerStatus ?? this.timerStatus,
      result: result = result ?? this.result,
    );
  }

  @override
  List<Object> get props => [
        timerStatus,
        result,
      ];
}
