part of 'dialog_bloc.dart';

enum TimerStatus { initial, play, pause, stop, wasChange }

class DialogState extends Equatable {
  const DialogState(
      {required this.babySleepTime,
      required this.babyWakeUpTime,
      this.timerStatus = TimerStatus.initial});

  final TimerStatus timerStatus;
  final DateTime babySleepTime;
  final DateTime babyWakeUpTime;

  DialogState copyWith(
      {TimerStatus? timerStatus,
      DateTime? babySleepTime,
      DateTime? babyWakeUpTime}) {
    return DialogState(
        timerStatus: timerStatus ?? this.timerStatus,
        babySleepTime: babySleepTime ?? this.babySleepTime,
        babyWakeUpTime: babyWakeUpTime ?? this.babyWakeUpTime);
  }

  @override
  List<Object> get props => [babySleepTime, babyWakeUpTime, timerStatus];
}
