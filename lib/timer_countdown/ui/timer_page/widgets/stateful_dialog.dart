import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';

enum AlertPageStatus { first, second }

enum ChangeBabyTime { sleep, aweken }

class StatefulDialog extends StatefulWidget {
  const StatefulDialog({super.key});

  @override
  State<StatefulDialog> createState() => _StatefulDialogState();
}

class _StatefulDialogState extends State<StatefulDialog> {
  DateTime? newPickedDate;
  TimeOfDay? newPickedTime;

  bool isUserEditTime = false;
  bool isUserEditDate = false;
  bool isUserEditDateTime = false;

  late DateTime newPickedDateAndTime;

  late ChangeBabyTime startOrStop;

  AlertPageStatus alertPageStatus = AlertPageStatus.first;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return StatefulBuilder(builder: (context, customSetStater) {
          return AlertDialog(
            title: const Text('Alert Dialog'),
            content: Row(
              children: [
                if (alertPageStatus == AlertPageStatus.first)
                  TextButton(
                      onPressed: () {
                        customSetStater(() {
                          alertPageStatus = AlertPageStatus.second;
                          startOrStop = ChangeBabyTime.sleep;
                        });
                      },
                      child: const Text('Начало')),
                if (alertPageStatus == AlertPageStatus.first)
                  TextButton(
                      onPressed: () {
                        customSetStater(() {
                          alertPageStatus = AlertPageStatus.second;
                          startOrStop = ChangeBabyTime.aweken;
                        });
                      },
                      child: const Text('Конец')),
                if (alertPageStatus == AlertPageStatus.second)
                  TextButton(
                      onPressed: () async {
                        newPickedDate =
                            await _showDatePicker(context.read<TimerBloc>());
                      },
                      child: Text(startOrStop == ChangeBabyTime.sleep
                          ? Validator().creatingDataDay(
                              context.read<TimerBloc>().state.babySleepTime)
                          : Validator().creatingDataDay(context
                              .read<TimerBloc>()
                              .state
                              .babyWakeUpTime))), // TODOD
                if (alertPageStatus == AlertPageStatus.second)
                  TextButton(
                      onPressed: () async {
                        newPickedTime =
                            await _showTimePicker(context.read<TimerBloc>());
                      },
                      child: Text(startOrStop == ChangeBabyTime.sleep
                          ? Validator().formatTheTime(
                              context.read<TimerBloc>().state.babySleepTime)
                          : Validator().formatTheTime(
                              context.read<TimerBloc>().state.babyWakeUpTime)))
              ],
            ),
            actions: [
              if (alertPageStatus == AlertPageStatus.first)
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK')),
              if (alertPageStatus == AlertPageStatus.second)
                TextButton(
                    onPressed: () {
                      if (!isUserEditDateTime) {
                        log('IS it logged from condition isUserEditDateTime');
                        updatedChildSleepAndAwekenTimeLogic(context);
                      }
                      Navigator.pop(context);
                      alertPageStatus = AlertPageStatus.first;
                    },
                    child: const Text('ОК'))
            ],
          );
        });
      },
    );
  }

  void updatedChildSleepAndAwekenTimeLogic(BuildContext context) {
    final now = DateTime.now();
    log('${now.hour}:${now.minute}');
    if (newPickedTime != null || newPickedDate != null) {
      newPickedDate ??= now;
      newPickedTime ??= TimeOfDay.fromDateTime(now);
      newPickedDateAndTime = DateTime(newPickedDate!.year, newPickedDate!.month,
          newPickedDate!.day, newPickedTime!.hour, newPickedTime!.minute);

      if (startOrStop == ChangeBabyTime.aweken) {
        log('Когда меняю время пробуждение малыша');
        log(newPickedDateAndTime.toString(),
            name: 'Это его новое время пробуждение');
        log(context.read<TimerBloc>().state.babySleepTime.toString(),
            name: 'Это его  время когда он уснул');

        context.read<TimerBloc>().add(TimerGetNewDateTimeForEnd(
            newDatetime: context.read<TimerBloc>().state.babySleepTime,
            stopTime: newPickedDateAndTime,
            now: DateTime.now()));
      } else {
        context.read<TimerBloc>().add(TimerGetNewTimes(
              newDatetime: newPickedDateAndTime,
              stopTime: context.read<TimerBloc>().state.babyWakeUpTime,
              now: now,
            ));
      }
    }

    alertPageStatus = AlertPageStatus.first;
  }

  Future<DateTime?> _showDatePicker(TimerBloc timerBloc) async {
    return showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      initialDate: timerBloc.state.babySleepTime,
    ).then((value) {
      log('Its happen if i close the datePicker and its Value: $value');
      if (value != null) {
        isUserEditDate = true;
        final now = DateTime.now();
        int hour;
        int minute;

        if (startOrStop == ChangeBabyTime.sleep) {
          if (isUserEditTime) {
            hour = timerBloc.state.babySleepTime.hour;
            minute = timerBloc.state.babySleepTime.minute;
          } else {
            hour = now.hour;
            minute = now.minute;
          }
          timerBloc.add(TimerGetNewTimes(
            newDatetime: DateTime(
              value.year,
              value.month,
              value.day,
              hour,
              minute,
            ),
            stopTime: timerBloc.state.babyWakeUpTime,
            now: now,
          )); // TODO ASK НЕ зннаю какое время указать
        } else {
          if (isUserEditTime) {
            hour = timerBloc.state.babyWakeUpTime.hour;
            minute = timerBloc.state.babyWakeUpTime.minute;
          } else {
            hour = now.hour;
            minute = now.minute;
          }
          timerBloc.add(TimerGetNewDateTimeForEnd(
              newDatetime: timerBloc.state.babySleepTime,
              stopTime: DateTime(
                value.year,
                value.month,
                value.day,
                hour,
                minute,
              ),
              now: now));
        }
        if (isUserEditDate && isUserEditTime) {
          isUserEditDateTime = true;
        }
      }
      return value;
    });
  }

  Future<TimeOfDay?> _showTimePicker(TimerBloc timerBloc) async {
    final initialTime = TimeOfDay.fromDateTime(timerBloc.state.babySleepTime);

    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
    ).then((value) {
      log('Its happen if i close the showTimePicker and its timeOfDay $value.');
      if (value != null) {
        isUserEditTime = true;
        final now = DateTime.now();
        int year;
        int month;
        int day;

        if (startOrStop == ChangeBabyTime.sleep) {
          if (isUserEditDate) {
            year = timerBloc.state.babySleepTime.year;
            month = timerBloc.state.babySleepTime.month;
            day = timerBloc.state.babySleepTime.day;
          } else {
            year = now.year;
            month = now.month;
            day = now.day;
          }
          timerBloc.add(TimerGetNewTimes(
            newDatetime: DateTime(year, month, day, value.hour, value.minute),
            stopTime: context.read<TimerBloc>().state.babyWakeUpTime,
            now: now,
          ));
        } else {
          if (isUserEditDate) {
            year = timerBloc.state.babyWakeUpTime.year;
            month = timerBloc.state.babyWakeUpTime.month;
            day = timerBloc.state.babyWakeUpTime.day;
          } else {
            year = now.year;
            month = now.month;
            day = now.day;
          }
          timerBloc.add(TimerGetNewDateTimeForEnd(
              newDatetime: timerBloc.state.babySleepTime,
              stopTime: DateTime(year, month, day, value.hour, value.minute),
              now: DateTime.now()));
        }

        if (isUserEditDate && isUserEditTime) {
          isUserEditDateTime = true;
        }
      }
      return value;
    });
  }
}
