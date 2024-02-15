import 'dart:developer';

import 'package:time_countdown/timer_countdown/data/globals/globals.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_model.dart';

class ChildrenRepository {
  Future<void> testCreateChild() async {
    await childrenDatabase.testInsertBabyAli();
  
  }

  Future<List<ChildModel>> testGetAllChild() async {
    var children = <ChildModel>[];
    try {
      children = await childrenDatabase.getChildren();
      return children;
    } on Exception catch (error) {
      log(error.toString(), name: 'Errors on getChildrens testGetAllChild');
      rethrow; // TODO изучить что делает и разницу между rethrow and throw error
    }
  }

  Future<void> deletaAll() async {
    await childrenDatabase.deletaAll();
  }
}
