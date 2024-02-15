part of 'timer_bloc.dart';

enum TimerStatus { initial, play, pause, stop, wasChange }

enum TimerPageStatus { initial, success, failure, loading }

class TimerState extends Equatable {
  const TimerState({
    this.timerStatus = TimerStatus.initial,
    
    List<ChildModel>? listChildren,
    List<ChildSleepTimeStatModel>? listChildSleepTimeStats,
    this.timerPageStatus = TimerPageStatus.initial,
  })  : listChildren = listChildren ?? const [],
        listChildSleepTimeStats = listChildSleepTimeStats ?? const [];
  final TimerStatus timerStatus;

  final List<ChildModel> listChildren;
  final TimerPageStatus timerPageStatus;
  final List<ChildSleepTimeStatModel> listChildSleepTimeStats;

  TimerState copyWith({
    TimerStatus? timerStatus,
   
    List<ChildModel>? listChildren,
    TimerPageStatus? timerPageStatus,
    List<ChildSleepTimeStatModel>? listChildSleepTimeStats
  }) {
    return TimerState(
        timerStatus: timerStatus = timerStatus ?? this.timerStatus,
       
        listChildren: listChildren = listChildren ?? this.listChildren,
        timerPageStatus: timerPageStatus =
            timerPageStatus ?? this.timerPageStatus,
        listChildSleepTimeStats: listChildSleepTimeStats ?? this.listChildSleepTimeStats
            );
  }

  @override
  List<Object> get props =>
      [timerStatus, listChildren, timerPageStatus,listChildSleepTimeStats];
}
