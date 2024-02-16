import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({super.key});

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  DateTime? _newPickedDate;
  TimeOfDay? _newPickedTime;

  late DateTime newPickedDateAndTime;
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return AlertDialog(
      title: const Text('Выберите дату сна'),
      content: Row(
        children: [
          TextButton(
              onPressed: () async {
                _newPickedDate =
                    await _showDatePicker(context.read<TimerBloc>());
                setState(() {});
              },
              child: Text(Validator().creatingDataDay(_newPickedDate ?? now))),
          TextButton(
              onPressed: () async {
                _newPickedTime =
                    await _showTimePicker(context.read<TimerBloc>());
                setState(() {});
              },
              child: Text(Validator().formatTheTimeOfDay(_newPickedTime ??
                  TimeOfDay.fromDateTime(_newPickedDate ?? now))))
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
  }

  void playTimerFromIconEditPressedOk(DateTime now, BuildContext context) {
    _newPickedDate ??= now;
    _newPickedTime ??= TimeOfDay.fromDateTime(now);
    newPickedDateAndTime = DateTime(_newPickedDate!.year, _newPickedDate!.month,
        _newPickedDate!.day, _newPickedTime!.hour, _newPickedTime!.minute);

    context.read<TimerBloc>().add(TimerGetNewTimes(
          newDatetime: newPickedDateAndTime,
          stopTime: context.read<TimerBloc>().state.babyWakeUpTime,
          now: now,
        ));
  }

  Future<DateTime?> _showDatePicker(TimerBloc timerBloc) async {
    return showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      initialDate: timerBloc.state.babySleepTime,
    ).then((value) {
      _newPickedDate = value;
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
      _newPickedTime = value;
      return value;
    });
  }
}
