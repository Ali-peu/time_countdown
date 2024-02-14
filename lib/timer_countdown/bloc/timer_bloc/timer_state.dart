part of 'timer_bloc.dart';

enum TimerStatus { initial, play, pause, stop, wasChange }

class TimerState extends Equatable {
  const TimerState(
      {this.timerStatus = TimerStatus.initial,
      this.result = '',
      this.alertDialog = ''});
  final TimerStatus timerStatus;
  final String result;
  final String alertDialog;

  TimerState copyWith({
    TimerStatus? timerStatus,
    String? result,
    String? alertDialog,
  }) {
    return TimerState(
        timerStatus: timerStatus = timerStatus ?? this.timerStatus,
        result: result = result ?? this.result,
        alertDialog: alertDialog ?? this.alertDialog);
  }

  @override
  List<Object> get props => [timerStatus, result, alertDialog];
}
