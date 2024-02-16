import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:time_countdown/timer_countdown/domain/models/timer_state_model.dart';

import 'package:time_countdown/timer_countdown/domain/repository/timer_page_bloc_repostory.dart';

part 'dialog_event.dart';
part 'dialog_state.dart';

class DialogBloc extends Bloc<DialogEvent, DialogState> {
  TimerPageBlocRepostory timerPageBlocRepostory;
  DialogBloc({required this.timerPageBlocRepostory})
      : super(DialogState(
            babySleepTime: DateTime.now(), babyWakeUpTime: DateTime.now())) {
    on<TimerStart>((event, emit) {
      timerPageBlocRepostory.addElement(TimerStateModel(
          sleepStartDateTime: event.startDateTime,
          awokenDateTime: DateTime.now(),
          timeStateStatus: TimerStateStatus.continueTimer));
      emit(state.copyWith(
          babySleepTime: event.startDateTime, timerStatus: TimerStatus.play));
    });
    on<TimerGetNewDateTimeForEnd>((event, emit) {
      timerPageBlocRepostory.addElement(TimerStateModel(
          sleepStartDateTime: event.newDatetime,
          awokenDateTime: event.stopTime,
          timeStateStatus: TimerStateStatus.continueTimer));
      emit(state.copyWith(
          babyWakeUpTime: event.stopTime, babySleepTime: event.newDatetime));
    });
    on<TimerError>((event, emit) {
      timerPageBlocRepostory.addElement(TimerStateModel(
          sleepStartDateTime: DateTime.now(),
          awokenDateTime: DateTime.now(),
          timeStateStatus: TimerStateStatus.errorTimer));
      emit(state.copyWith());
    });
    on<TimerStop>((event, emit) {
      timerPageBlocRepostory.addElement(TimerStateModel(
          sleepStartDateTime: DateTime.now(),
          awokenDateTime: event.dateTime,
          timeStateStatus: TimerStateStatus.resetTimer));
      emit(state.copyWith(
          babyWakeUpTime: event.dateTime, timerStatus: TimerStatus.stop));
    });
    on<TimerGetNewTimes>((event, emit) {
      timerPageBlocRepostory.addElement(TimerStateModel(
          sleepStartDateTime: event.newDatetime,
          awokenDateTime: event.stopTime,
          timeStateStatus: TimerStateStatus.continueTimer));
      emit(state.copyWith(
          babyWakeUpTime: event.stopTime, babySleepTime: event.newDatetime));
    });
  }
}
