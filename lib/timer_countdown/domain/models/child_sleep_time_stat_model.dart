
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:time_countdown/timer_countdown/data/local_db/children_db/children_db.dart';
import 'package:time_countdown/timer_countdown/data/local_db/children_sleeps_db/child_sleep_time_stat.dart';

class ChildSleepTimeStatModel extends Equatable {
  final DateTime babySleepDateTime;
  final DateTime babyWakeUpDateTime;
  final Duration duration;
  final int babyId;

  const ChildSleepTimeStatModel(
      {required this.babySleepDateTime,
      required this.babyWakeUpDateTime,
      required this.duration,
      required this.babyId});

  ChildSleepTimeStatModel.fromLocal(ChildSleepTimeStatData data)
      : babySleepDateTime = data.babySleepDateTime,
        babyWakeUpDateTime = data.babyWakeUpDateTime,
        babyId = data.babyId,
        duration = Duration(seconds: data.duration);

  ChildSleepTimeStatCompanion childModeloChildrenCompanion() {
    final sleepDateTime = Value<DateTime>(babySleepDateTime);
    final wakeUpDateTime = Value<DateTime>(babyWakeUpDateTime);
    final durationInInt = Value<int>(duration.inSeconds);
    final childId = Value<int>(babyId);

    return ChildSleepTimeStatCompanion(
        babyId: childId,
        babySleepDateTime: sleepDateTime,
        babyWakeUpDateTime: wakeUpDateTime,
        duration: durationInInt);
  }

  @override
  List<Object?> get props =>
      [babySleepDateTime, babyWakeUpDateTime, duration, babyId];
}
