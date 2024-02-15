import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';

class EditIcon extends StatefulWidget {
  const EditIcon({super.key});

  @override
  State<EditIcon> createState() => _EditIconState();
}

class _EditIconState extends State<EditIcon> {
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
  ) async{
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Выберите дату сна"),
            content: Row(
              children: [
                TextButton(
                    onPressed: () async {
                      newPickedDate =
                          await _showDatePicker(context.read<TimerBloc>());
                    },
                    child: const Text('День')),
                TextButton(
                    onPressed: () async {
                      newPickedTime =
                          await _showTimePicker(context.read<TimerBloc>());
                    },
                    child: const Text('Время'))
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (newPickedTime != null) {
                      newPickedDate ??= now;
                      newPickedTime ?? TimeOfDay.fromDateTime(now);
                      newPickedDateAndTime = DateTime(
                          newPickedDate!.year,
                          newPickedDate!.month,
                          newPickedDate!.day,
                          newPickedTime!.hour,
                          newPickedTime!.minute);

                      context.read<TimerBloc>().add(TimerGetNewTimes(
                            newDatetime: newPickedDateAndTime,
                            stopTime:
                                context.read<TimerBloc>().unredactedStopTime ??
                                    DateTime.now(),
                            now: now,
                          ));
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('ОК')),
            ],
          );
        });
  }

  Future<DateTime?> _showDatePicker(TimerBloc timerBloc) async {
    return await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      initialDate: timerBloc.unredactedStartTime ?? DateTime.now(),
    );
  }

  Future<TimeOfDay?> _showTimePicker(TimerBloc timerBloc) async {
    TimeOfDay initialTime;
    if (timerBloc.unredactedStartTime != null) {
      initialTime = TimeOfDay.fromDateTime(timerBloc.unredactedStartTime!);
    } else {
      initialTime = TimeOfDay.fromDateTime(DateTime.now());
    }

    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
    );
  }
}
