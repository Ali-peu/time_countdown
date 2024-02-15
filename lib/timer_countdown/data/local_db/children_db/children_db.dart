import 'dart:developer';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:time_countdown/timer_countdown/data/globals/globals.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_model.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_sleep_time_stat_model.dart';

part 'children_db.g.dart';

class Children extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  DateTimeColumn get babyBirthday => dateTime()();
  BoolColumn get gender => boolean()();
}

class ChildSleepTimeStat extends Table {
  IntColumn get statId => integer().autoIncrement()();
  IntColumn get babyId => integer()();
  DateTimeColumn get babySleepDateTime => dateTime()();
  DateTimeColumn get babyWakeUpDateTime => dateTime()();
  IntColumn get duration => integer()();
}
// ... the TodoItems table definition stays the same

@DriftDatabase(tables: [Children, ChildSleepTimeStat])
class ChildrenDatabase extends _$ChildrenDatabase {
  ChildrenDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> testInsert() async {
    await into(childSleepTimeStat).insert(ChildSleepTimeStatCompanion.insert(
        babySleepDateTime: DateTime.now(),
        babyId: 4,
        babyWakeUpDateTime: DateTime.now(),
        duration: 40));
  }

  Future<void> insertChildSleepTimeStat(ChildSleepTimeStatModel model) async {
    try {
      await into(childSleepTimeStat).insert(ChildSleepTimeStatCompanion.insert(
          babyId: model.babyId,
          babySleepDateTime: model.babySleepDateTime,
          babyWakeUpDateTime: model.babyWakeUpDateTime,
          duration: model.duration.inSeconds));
    } on Exception catch (error) {
      log(error.toString(),
          name:
              'Error on insert childSleepTimeStatCompanion into childSleepTimeStat');
    }
  }

  Future<List<ChildSleepTimeStatModel>> getChildSleepTimeStats() async {
    var childSleepTimeStats = [];
    log('getChildSleepTimeStats Future<List<ChildSleepTimeStatModel>> ChildSleepTimeStat');
    try {
      childSleepTimeStats =
          await select(childrenDatabase.childSleepTimeStat).get();
      log('Success on childSleepTimeStatDatabase');
    } on Exception catch (error) {
      log(error.toString(),
          name:
              'Errors on get childSleepTimeStat from childSleepTimeStatDatabase');
    }

    final result = <ChildSleepTimeStatModel>[];
    for (final childSleepTimeStat in childSleepTimeStats) {
      result.add(ChildSleepTimeStatModel.fromLocal(
          childSleepTimeStat as ChildSleepTimeStatData));
    }
    return result;
  }

  // Future<List<ChildSleepTimeStatModel>> getChildSleepTimeStatsWithBabyId(
  //     int id) async {
  //   var childSleepTimeStats = [];
  //   try {
  //     childSleepTimeStats = await select(table).where((tbl) => ).
  //   } on Exception catch (error) {
  //     log(error.toString(),
  //         name:
  //             'Errors on get childSleepTimeStat from childSleepTimeStatDatabase');
  //   }
  // }
  Future<void> testInsertBabyAli() async {
    await into(children).insert(ChildrenCompanion.insert(
        name: 'Ali', babyBirthday: DateTime(2007, 7, 20), gender: true));
  }

  Future<void> testInsertBabyNurbak() async {
    await into(children).insert(ChildrenCompanion.insert(
        name: 'Nurbak', babyBirthday: DateTime(2003, 5, 27), gender: true));
  }

  Future<void> testInsertBabyRandom() async {
    await into(children).insert(ChildrenCompanion.insert(
        name: 'Random', babyBirthday: DateTime(2000, 7, 13), gender: false));
  }

  Future<void> deletaAll() async {
    delete(childrenDatabase.children);
  }

  Future<List<ChildModel>> getChildren() async {
    var children = [];
    try {
      children = await select(childrenDatabase.children).get();
      log('Success on childrenDatabase');
    } on Exception catch (e) {
      log(e.toString(), name: 'Errors on get children from childrenDatabase');
    }

    final result = <ChildModel>[];
    for (final child in children) {
      result.add(ChildModel.fromLocal(child as ChildrenData));
    }

    log(result.toString(), name: 'ChildrenDatabase getChildren children');
    return result;
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
