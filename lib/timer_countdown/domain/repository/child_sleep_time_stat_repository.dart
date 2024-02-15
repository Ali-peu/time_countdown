import 'dart:developer';

import 'package:time_countdown/timer_countdown/data/globals/globals.dart';

import 'package:time_countdown/timer_countdown/domain/models/child_sleep_time_stat_model.dart';

class ChildSleepTimeStatRepository {
  Future<void> testInsert() async {
    await childrenDatabase.testInsert();
  }

  Future<List<ChildSleepTimeStatModel>> getchildSleepTimeStats() async {
    log(' Future<List<ChildSleepTimeStatModel>> getchildSleepTimeStats() ChildSleepTimeStatRepository:');
    final childAllSleepTimerStats =
        await childrenDatabase.getChildSleepTimeStats();
    return childAllSleepTimerStats;
  }

  Future<void> createChildAllSleepTimerStats(DateTime babySleepDateTime,
      DateTime babyWakeUpDateTime, Duration duration, int babyId) async {
    final model = ChildSleepTimeStatModel(
        babySleepDateTime: babySleepDateTime,
        babyWakeUpDateTime: babyWakeUpDateTime,
        duration: duration,
        babyId: babyId);

    await childrenDatabase.insertChildSleepTimeStat(model);
  }
}
