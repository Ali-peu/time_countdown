import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';

class EditIcon extends StatefulWidget {
  const EditIcon({super.key});

  @override
  State<EditIcon> createState() => _EditIconState();
}

class _EditIconState extends State<EditIcon> { // TODO Надо обнавить значение
  DateTime? newPickedDate;
  TimeOfDay? newPickedTime;

  late DateTime newPickedDateAndTime;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await alertDialogWithDateAndTimeForStartSleep(
              DateTime.now(), context);
        },
        icon: const Icon(Icons.edit));
  }

  Future<dynamic> alertDialogWithDateAndTimeForStartSleep(
    DateTime now,
    BuildContext context,
  ) async {
    return showDialog(
        context: context,
        builder: (_) {
          final now = DateTime.now();

          return AlertDialog(
            title: const Text('Выберите дату сна'),
            content: Row(
              children: [
                TextButton(
                    onPressed: () async {
                      newPickedDate =
                          await _showDatePicker(context.read<TimerBloc>());

                    
                    },
                    child: Text(
                        Validator().creatingDataDay(newPickedDate ?? now))),
                TextButton(
                    onPressed: () async {
                      newPickedTime =
                          await _showTimePicker(context.read<TimerBloc>());
                     
                    },
                    child: Text(Validator().formatTheTimeOfDay(newPickedTime ??
                        TimeOfDay.fromDateTime(newPickedDate ?? now))))
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    playTimerFromIconEditPressedOk(now, context);

                    Navigator.pop(context);
                  },
                  child: const Text('ОК')),
            ],
          );
        });
  }

  void playTimerFromIconEditPressedOk(DateTime now, BuildContext context) {
    if (newPickedTime != null || newPickedDate != null) {
      newPickedDate ??= now;
      newPickedTime ?? TimeOfDay.fromDateTime(now);
      newPickedDateAndTime = DateTime(newPickedDate!.year, newPickedDate!.month,
          newPickedDate!.day, newPickedTime!.hour, newPickedTime!.minute);

      context.read<TimerBloc>().add(TimerGetNewTimes(
            newDatetime: newPickedDateAndTime,
            stopTime: context.read<TimerBloc>().state.babyWakeUpTime,
            now: now,
          ));
    }
  }

  Future<DateTime?> _showDatePicker(TimerBloc timerBloc) async {
    return showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      initialDate: timerBloc.state.babySleepTime,
    ).then((value) {
      newPickedDate = value;
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
      newPickedTime = value;
      return value;
    });
  }
}
