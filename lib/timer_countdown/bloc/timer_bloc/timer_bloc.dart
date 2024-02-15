import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:time_countdown/timer_countdown/data/custom_timer.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_model.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_sleep_time_stat_model.dart';
import 'package:time_countdown/timer_countdown/domain/repository/child_sleep_time_stat_repository.dart';
import 'package:time_countdown/timer_countdown/domain/repository/children_repository.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  DateTime? _unredactedStartTime;
  DateTime? get unredactedStartTime => _unredactedStartTime;
  void setUnredactedStartTime(DateTime dateTime) {
    _unredactedStartTime = dateTime;
  }

  DateTime? _unredactedStopTime;
  DateTime? get unredactedStopTime => _unredactedStopTime;
  void setUnredactedStopTime(DateTime value) {
    _unredactedStopTime = value;
  }

  TimerService timerService = TimerService();

  ChildrenRepository childrenRepository;
  ChildSleepTimeStatRepository childSleepTimeStatRepository;

  TimerBloc(
      {required this.childrenRepository,
      required this.childSleepTimeStatRepository})
      : super(const TimerState()) {
    on<FetchedChildrens>((event, emit) async {
      await _onFetchedChildrens(emit);
    });
    on<FetchedListChildSleepTimeStats>((event, emit) async {
      var childSleepTimeStats = <ChildSleepTimeStatModel>[];
      childSleepTimeStats =
          await childSleepTimeStatRepository.getchildSleepTimeStats();

      emit(TimerState(
          listChildSleepTimeStats: childSleepTimeStats,
          listChildren: state.listChildren));
    });
    on<TimerStart>(_onTimerPlay);
    on<TimerStop>(_onTimerStop);

    on<TimerGetNewTimes>((event, emit) => _timerGetNewTimesOrRedected(event));
    on<TimerError>((event, emit) => timerError(emit));

    on<TimerGetNewDateTimeForEnd>(
        (event, emit) => _timerGetNewDateTimeForEnd(event));
  }

  Future<void> _onFetchedChildrens(Emitter<TimerState> emit) async {
    var childrens = <ChildModel>[];
    childrens = await childrenRepository.testGetAllChild();

    if (childrens.isEmpty) {
      emit(const TimerState(timerPageStatus: TimerPageStatus.failure));
    } else {
      emit(TimerState(
          listChildren: childrens, timerPageStatus: TimerPageStatus.success));
    }

    log('Log after emitts');
  }

  Future<void> _timerGetNewDateTimeForEnd(
      TimerGetNewDateTimeForEnd event) async {
    if (!event.stopTime.isAfter(unredactedStartTime!) ||
        event.stopTime.isAfter(event.now)) {
      add(TimerError());
    } else {
      setUnredactedStopTime(event.stopTime);
      timerService.updateStartTime(event.newDatetime, event.stopTime, 'Stop');
      add(TimerStart(startDateTime: unredactedStartTime!));
    }
  }

  Future<void> _timerGetNewTimesOrRedected(TimerGetNewTimes event) async {
    if (unredactedStartTime == null) {
      add(TimerStart(startDateTime: event.newDatetime));
    } else {
      if (event.newDatetime.isBefore(event.now) &&
          event.newDatetime.isBefore(event.stopTime)) {
        timerService.updateStartTime(
            event.newDatetime, event.stopTime, 'Start');
        setUnredactedStartTime(event.newDatetime);

        add(TimerStart(startDateTime: unredactedStartTime!));
      } else {
        add(TimerError());
      }
    }
  }

  Future<void> timerError(Emitter<TimerState> emit) async {
    emit(TimerState(
        timerStatus: TimerStatus.initial,
        listChildSleepTimeStats: state.listChildSleepTimeStats,
        listChildren: state.listChildren));
  }

  Future<void> _onTimerPlay(TimerStart event, Emitter<TimerState> emit) async {
    if (timerService.isClose()) {
      timerService = TimerService();
    }
    setUnredactedStartTime(event.startDateTime);
    timerService.startTimer(event.startDateTime);
    emit(TimerState(
        timerStatus: TimerStatus.play,
        listChildSleepTimeStats: state.listChildSleepTimeStats,
        listChildren: state.listChildren));
  }

  Future<void> _onTimerStop(TimerStop event, Emitter<TimerState> emit) async {
    setUnredactedStopTime(event.dateTime);

    final babySleepTime = unredactedStartTime ?? DateTime.now();
    final babyWakeUpTime = unredactedStopTime ?? DateTime.now();

    final duration = babyWakeUpTime.difference(babySleepTime);

    await childSleepTimeStatRepository.createChildAllSleepTimerStats(
        babySleepTime, babyWakeUpTime, duration, event.babyID);
    add(FetchedListChildSleepTimeStats());

    await timerService.stopTimer();
    await timerService.dispose();

    emit(TimerState(
        timerStatus: TimerStatus.stop,
        listChildSleepTimeStats: state.listChildSleepTimeStats,
        listChildren: state.listChildren));
  }
}
