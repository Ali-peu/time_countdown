import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:time_countdown/timer_countdown/data/custom_timer.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_model.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_sleep_time_stat_model.dart';
import 'package:time_countdown/timer_countdown/domain/repository/child_sleep_time_stat_repository.dart';
import 'package:time_countdown/timer_countdown/domain/repository/children_repository.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  // DateTime? _unredactedStartTime;
  // DateTime? get unredactedStartTime => _unredactedStartTime;

  // void setUnredactedStartTime(DateTime dateTime) {
  //   _unredactedStartTime = dateTime;
  // }

  // DateTime? _unredactedStopTime;
  // DateTime? get unredactedStopTime => _unredactedStopTime;
  // void setUnredactedStopTime(DateTime value) {
  //   _unredactedStopTime = value;
  // }

  TimerService timerService = TimerService();

  ChildrenRepository childrenRepository;
  ChildSleepTimeStatRepository childSleepTimeStatRepository;

  TimerBloc(
      {required this.childrenRepository,
      required this.childSleepTimeStatRepository})
      : super(TimerState(
            babySleepTime: DateTime.now(),
            babyWakeUpTime: DateTime.now(),
            now: DateTime.now(),
            choosenBabyId: 0)) {
    on<FetchedChildrens>((event, emit) async {
      await _onFetchedChildrens(emit);
    });
    on<FetchedListChildSleepTimeStats>((event, emit) async {
      var childSleepTimeStats = <ChildSleepTimeStatModel>[];
      childSleepTimeStats =
          await childSleepTimeStatRepository.getchildSleepTimeStats();

      emit(TimerState(
          now: DateTime.now(),
          timerPageStatus: state.timerPageStatus,
          timerStatus: state.timerStatus,
          babySleepTime: state.babySleepTime,
          babyWakeUpTime: state.babyWakeUpTime,
          listChildSleepTimeStats: childSleepTimeStats,
          listChildren: state.listChildren,
          choosenBabyId: state.choosenBabyId));
    });

    on<UpdateDefautlState>((event, emit) {
      emit(TimerState(
          now: DateTime.now(),
          babySleepTime: state.babySleepTime,
          babyWakeUpTime: event.stopTime,
          timerStatus: state.timerStatus,
          listChildren: state.listChildren,
          listChildSleepTimeStats: state.listChildSleepTimeStats,
          timerPageStatus: state.timerPageStatus,
          choosenBabyId: state.choosenBabyId));
    });
    on<GetPickedChildId>((event, emit) {
      emit(TimerState(
          now: DateTime.now(),
          babySleepTime: state.babySleepTime,
          babyWakeUpTime: state.babyWakeUpTime,
          timerStatus: state.timerStatus,
          listChildren: state.listChildren,
          listChildSleepTimeStats: state.listChildSleepTimeStats,
          timerPageStatus: state.timerPageStatus,
          choosenBabyId: event.pickedBabyId));
    });
    on<TimerStart>(_onTimerPlay);
    on<TimerStop>(_onTimerStop);

    on<TimerGetNewTimes>(_timerGetNewTimesOrRedected);
    on<TimerError>((event, emit) => timerError(emit));

    on<TimerGetNewDateTimeForEnd>(_timerGetNewDateTimeForEnd);
  }

  Future<void> _onFetchedChildrens(Emitter<TimerState> emit) async {
    var childrens = <ChildModel>[];
    childrens = await childrenRepository.testGetAllChild();

    if (childrens.isEmpty) {
      emit(TimerState(
          now: DateTime.now(),
          timerPageStatus: TimerPageStatus.failure,
          babySleepTime: state.babySleepTime,
          babyWakeUpTime: state.babyWakeUpTime,
          choosenBabyId: 0));
    } else {
      emit(TimerState(
          now: DateTime.now(),
          listChildren: childrens,
          timerPageStatus: TimerPageStatus.success,
          babySleepTime: state.babySleepTime,
          babyWakeUpTime: state.babyWakeUpTime,
          choosenBabyId: childrens.first.childId));
    }

    log('Log after emitts');
  }

  Future<void> _timerGetNewDateTimeForEnd(
      TimerGetNewDateTimeForEnd event, Emitter<TimerState> emit) async {
    if (event.stopTime.isBefore(state.babySleepTime) ||
        event.stopTime.isAfter(event.now)) {
      log('Do timer Error in event TimerGetNewDateTimeForEnd');
      add(TimerError());
    } else {
      log(event.newDatetime.toString(),
          name: 'event.stopTime.toString() from EVENT');
      log(event.stopTime.toString(),
          name: 'event.stopTime.toString() from EVENT');
      await timerService.updateStartTime(
          event.newDatetime, event.stopTime, 'Stop');
      emit(TimerState(
          now: DateTime.now(),
          timerPageStatus: state.timerPageStatus,
          babySleepTime: state.babySleepTime,
          babyWakeUpTime: event.stopTime,
          timerStatus: state.timerStatus,
          listChildSleepTimeStats: state.listChildSleepTimeStats,
          listChildren: state.listChildren,
          choosenBabyId: state.choosenBabyId));
      add(TimerStart(startDateTime: state.babySleepTime));
    }
  }

  Future<void> _timerGetNewTimesOrRedected(
      TimerGetNewTimes event, Emitter<TimerState> emit) async {
    if (state.babySleepTime == DateTime.now()) {
      add(TimerStart(startDateTime: event.newDatetime));
    } else {
      if (event.newDatetime.isBefore(event.now) &&
          event.newDatetime.isBefore(event.stopTime)) {
        await timerService.updateStartTime(
            event.newDatetime, event.stopTime, 'Start');
        emit(TimerState(
            now: DateTime.now(),
            timerPageStatus: state.timerPageStatus,
            babySleepTime: event.newDatetime,
            babyWakeUpTime: state.babyWakeUpTime,
            timerStatus: state.timerStatus,
            listChildSleepTimeStats: state.listChildSleepTimeStats,
            listChildren: state.listChildren,
            choosenBabyId: state.choosenBabyId));

        add(TimerStart(startDateTime: state.babySleepTime));
      } else {
        add(TimerError());
      }
    }
  }

  Future<void> timerError(Emitter<TimerState> emit) async {
    emit(TimerState(
        now: DateTime.now(),
        timerPageStatus: state.timerPageStatus,
        babySleepTime: state.babySleepTime,
        babyWakeUpTime: state.babyWakeUpTime,
        timerStatus: state.timerStatus,
        listChildSleepTimeStats: state.listChildSleepTimeStats,
        listChildren: state.listChildren,
        choosenBabyId: state.choosenBabyId));
  }

  Future<void> _onTimerPlay(TimerStart event, Emitter<TimerState> emit) async {
    if (timerService.isClose()) {
      timerService = TimerService();
    }
    timerService.startTimer(event
        .startDateTime); // TODO нужен ли emittit конец таймере babyWakeUpTime

    emit(TimerState(
        now: DateTime.now(),
        babySleepTime: event.startDateTime,
        babyWakeUpTime: state.babyWakeUpTime,
        timerPageStatus: state.timerPageStatus,
        timerStatus: TimerStatus.play,
        listChildSleepTimeStats: state.listChildSleepTimeStats,
        listChildren: state.listChildren,
        choosenBabyId: state.choosenBabyId));
    // setUnredactedStartTime(event.startDateTime);
    // timerService.startTimer(event.startDateTime);
    // emit(TimerState(
    //     timerStatus: TimerStatus.play,
    //     listChildSleepTimeStats: state.listChildSleepTimeStats,
    //     listChildren: state.listChildren));
  }

  Future<void> _onTimerStop(TimerStop event, Emitter<TimerState> emit) async {
    emit(TimerState(
      now: DateTime.now(),
      timerPageStatus: state.timerPageStatus,
      timerStatus: TimerStatus.stop,
      listChildSleepTimeStats: state.listChildSleepTimeStats,
      listChildren: state.listChildren,
      babySleepTime: state.babySleepTime,
      babyWakeUpTime: state.babyWakeUpTime,
      choosenBabyId: state.choosenBabyId, // Проверить точно ли изменилась
    ));

    final babySleepTime = state.babySleepTime;
    final babyWakeUpTime = state.babyWakeUpTime;
    final duration = babyWakeUpTime.difference(babySleepTime);
    await childSleepTimeStatRepository.createChildAllSleepTimerStats(
        babySleepTime, babyWakeUpTime, duration, event.babyID);
    add(FetchedListChildSleepTimeStats());

    await timerService.stopTimer();
    await timerService.dispose();
  }
}
