import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';

enum AlertPageStatus { first, second }

class StatefulDialog extends StatefulWidget {
  const StatefulDialog({super.key});

  @override
  State<StatefulDialog> createState() => _StatefulDialogState();
}

class _StatefulDialogState extends State<StatefulDialog> {
  DateTime? newPickedDate;
  TimeOfDay? newPickedTime;

  late DateTime newPickedDateAndTime;

  late String startOrStop;

  AlertPageStatus alertPageStatus = AlertPageStatus.first;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return StatefulBuilder(builder: (context, customSetStater) {
          return AlertDialog(
            title: Text('Alert Dialog'),
            content: Row(
              children: [
                if (alertPageStatus == AlertPageStatus.first)
                  TextButton(
                      onPressed: () {
                        customSetStater(() {
                          alertPageStatus = AlertPageStatus.second;
                          startOrStop = 'Start';
                        });
                      },
                      child: const Text('Начало')),
                if (alertPageStatus == AlertPageStatus.first)
                  TextButton(
                      onPressed: () {
                        customSetStater(() {
                          alertPageStatus = AlertPageStatus.second;
                          startOrStop = 'Stop';
                        });
                      },
                      child: const Text('Конец')),
                if (alertPageStatus == AlertPageStatus.second)
                  TextButton(
                      onPressed: () async {
                        newPickedDate =
                            await _showDatePicker(context.read<TimerBloc>());
                      },
                      child: const Text('Дата')),
                if (alertPageStatus == AlertPageStatus.second)
                  TextButton(
                      onPressed: () async {
                        newPickedTime =
                            await _showTimePicker(context.read<TimerBloc>());
                      },
                      child: const Text('Время'))
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
                      DateTime now = DateTime.now();
                      if (newPickedTime != null) {
                        newPickedDate ??= now;
                        newPickedTime ?? TimeOfDay.fromDateTime(now);
                        newPickedDateAndTime = DateTime(
                            newPickedDate!.year,
                            newPickedDate!.month,
                            newPickedDate!.day,
                            newPickedTime!.hour,
                            newPickedTime!.minute);

                        if (startOrStop == 'Stop') {
                          context.read<TimerBloc>().add(
                              TimerGetNewDateTimeForEnd(
                                  newDatetime: context
                                      .read<TimerBloc>()
                                      .unredactedStartTime!,
                                  stopTime: newPickedDateAndTime,
                                  now: now));
                        } else {
                          context.read<TimerBloc>().add(TimerGetNewTimes(
                                newDatetime: newPickedDateAndTime,
                                stopTime: context
                                        .read<TimerBloc>()
                                        .unredactedStopTime ??
                                    DateTime.now(),
                                now: now,
                              ));
                        }
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
