part of 'timer_bloc.dart';

enum TimerStatus { initial, play, pause, stop, wasChange }

enum TimerPageStatus { initial, success, failure, loading }

class TimerState extends Equatable {
  const TimerState(
      {required this.now,
      required this.babySleepTime,
      required this.babyWakeUpTime,
      this.choosenBabyId = 0, // TODO В базе нет ребенка с id == 0
      this.timerStatus = TimerStatus.initial,
      List<ChildModel>? listChildren,
      List<ChildSleepTimeStatModel>? listChildSleepTimeStats,
      this.timerPageStatus = TimerPageStatus.initial})
      : listChildren = listChildren ?? const [],
        listChildSleepTimeStats = listChildSleepTimeStats ?? const [];

  final TimerStatus timerStatus;
  final List<ChildModel> listChildren;
  final TimerPageStatus timerPageStatus;
  final List<ChildSleepTimeStatModel> listChildSleepTimeStats;
  final DateTime babySleepTime;
  final DateTime babyWakeUpTime;
  final DateTime now;
  final int choosenBabyId;

  TimerState copyWith({
    TimerStatus? timerStatus,
    List<ChildModel>? listChildren,
    TimerPageStatus? timerPageStatus,
    List<ChildSleepTimeStatModel>? listChildSleepTimeStats,
    DateTime? babySleepTime,
    DateTime? babyWakeUpTime,
    DateTime? now,
    int? choosenBabyId,
  }) {
    return TimerState(
        timerStatus: timerStatus ?? this.timerStatus,
        listChildren: listChildren ?? this.listChildren,
        timerPageStatus: timerPageStatus ?? this.timerPageStatus,
        listChildSleepTimeStats:
            listChildSleepTimeStats ?? this.listChildSleepTimeStats,
        now: now ?? this.now,
        babySleepTime: babySleepTime ?? this.babySleepTime,
        babyWakeUpTime: babyWakeUpTime ?? this.babyWakeUpTime,
        choosenBabyId: choosenBabyId ?? this.choosenBabyId);
  }

  @override
  List<Object> get props => [
        babySleepTime,
        babyWakeUpTime,
        timerStatus,
        listChildren,
        timerPageStatus,
        listChildSleepTimeStats,
        now,
        choosenBabyId
      ];
}
