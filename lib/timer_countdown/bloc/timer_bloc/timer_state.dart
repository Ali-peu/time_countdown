part of 'timer_bloc.dart';

enum TimerStatus { initial, play, pause, stop, wasChange }

enum TimerPageStatus { initial, success, failure, loading }

class TimerState extends Equatable {
  const TimerState(
      {required this.now,
      required this.babySleepTime,
      required this.babyWakeUpTime,
      required this.choosenBabyId,
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


  @override
  List<Object> get props => [
        timerStatus,
        listChildren,
        timerPageStatus,
        listChildSleepTimeStats,
        babySleepTime,
        babyWakeUpTime,
        now,
      ];
}
