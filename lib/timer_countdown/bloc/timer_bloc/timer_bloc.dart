import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:time_countdown/timer_countdown/data/custom_timer_servise.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_model.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_sleep_time_stat_model.dart';
import 'package:time_countdown/timer_countdown/domain/repository/child_sleep_time_stat_repository.dart';
import 'package:time_countdown/timer_countdown/domain/repository/children_repository.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerService timerService = TimerService();

  final ChildrenRepository _childrenRepository;
  final ChildSleepTimeStatRepository _childSleepTimeStatRepository;

  TimerBloc(
      {required ChildrenRepository childrenRepository,
      required ChildSleepTimeStatRepository childSleepTimeStatRepository})
      : _childSleepTimeStatRepository = childSleepTimeStatRepository,
        _childrenRepository = childrenRepository,
        super(TimerState(
          babySleepTime: DateTime.now(),
          babyWakeUpTime: DateTime.now(),
          now: DateTime.now(),
        )) {
    on<FetchedChildrens>((event, emit) => _onFetchedChildrens(emit));

    on<FetchedListChildSleepTimeStats>(
        (event, emit) => _onFetchedListChildSleepTimeStats(emit));

    on<UpdateDefautlState>((event, emit) => _onUpdateDefautlState(emit, event));

    on<GetPickedChildId>((event, emit) => _onGetPickedChildId(emit, event));

    on<TimerStart>(_onTimerPlay);

    on<TimerStop>(_onTimerStop);

    on<TimerGetNewTimes>(_timerGetNewTimesOrRedected);

    on<TimerError>((event, emit) => timerError(emit));

    on<TimerGetNewDateTimeForEnd>(_timerGetNewDateTimeForEnd);
  }

  Future<void> _onGetPickedChildId(
      Emitter<TimerState> emit, GetPickedChildId event) async {
    emit(
        state.copyWith(choosenBabyId: event.pickedBabyId, now: DateTime.now()));
  }

  Future<void> _onUpdateDefautlState(
      Emitter<TimerState> emit, UpdateDefautlState event) async {
    emit(state.copyWith(
      babyWakeUpTime: event.stopTime,
      now: DateTime.now(),
    ));
  }

  Future<void> _onFetchedListChildSleepTimeStats(
      Emitter<TimerState> emit) async {
    var childSleepTimeStats = <ChildSleepTimeStatModel>[];
    childSleepTimeStats =
        await _childSleepTimeStatRepository.getchildSleepTimeStats();
    log(state.listChildren.toString(),
        name: '_onFetchedListChildSleepTimeStats: ');

    emit(state.copyWith(
      listChildSleepTimeStats: childSleepTimeStats,
      now: DateTime.now(),
    ));
  }

  Future<void> _onFetchedChildrens(Emitter<TimerState> emit) async {
    var childrens = <ChildModel>[];
    childrens = await _childrenRepository.testGetAllChild();
    emit(state.copyWith(
        now: DateTime.now(),
        listChildren: childrens,
        timerPageStatus: TimerPageStatus.success,
        choosenBabyId: childrens.first.childId));
  }

  Future<void> _timerGetNewDateTimeForEnd(
      TimerGetNewDateTimeForEnd event, Emitter<TimerState> emit) async {
    if (event.stopTime.isBefore(state.babySleepTime) ||
        event.stopTime.isAfter(event.now)) {
      add(TimerError());
    } else {
      await timerService.updateStartTime(
          event.newDatetime, event.stopTime, TimerServiseStatus.stop);
      emit(state.copyWith(
        now: DateTime.now(),
        babyWakeUpTime: event.stopTime,
      ));
      add(TimerStart(
        startDateTime: event.newDatetime,
      ));
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
            event.newDatetime, event.stopTime, TimerServiseStatus.start);
        emit(state.copyWith(
          babySleepTime: event.newDatetime,
          now: DateTime.now(),
        ));

        add(TimerStart(
            startDateTime:
                event.newDatetime)); // WAS HERE state.babSleepDateTime
      } else {
        add(TimerError());
      }
    }
  }

  Future<void> timerError(Emitter<TimerState> emit) async {
    emit(state.copyWith(
      now: DateTime.now(),
    ));
  }

  Future<void> _onTimerPlay(TimerStart event, Emitter<TimerState> emit) async {
    if (timerService.isClose()) {
      timerService = TimerService();
    }
    timerService.startTimer(event.startDateTime);
    emit(state.copyWith(
      timerStatus: TimerStatus.play,
      now: DateTime.now(),
      babySleepTime: event.startDateTime,
    ));
  }

  Future<void> _onTimerStop(TimerStop event, Emitter<TimerState> emit) async {
    final babySleepTime = state.babySleepTime;
    final babyWakeUpTime = state.babyWakeUpTime;
    final duration = babyWakeUpTime.difference(babySleepTime);
    await _childSleepTimeStatRepository.createChildSleepTimerStat(
        babySleepTime, babyWakeUpTime, duration, event.babyID);
    add(FetchedListChildSleepTimeStats());

    // await timerService.stopTimer();
    // await timerService.dispose();
    emit(state.copyWith(
      timerStatus: TimerStatus.stop,
      now: DateTime.now(),
    ));
  }
}
