import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/second_timer.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  void initState() {
    super.initState();
    log(DateTime.now().toString(), name: 'Init State Системное время:');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          var timerBloc = context.read<TimerBloc>();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [timerInState(timerBloc), playButton(timerBloc, state)],
            ),
          );
        },
      ),
    );
  }

  BlocProvider<TimerBloc> timerInState(TimerBloc timerBloc) {
    return BlocProvider.value(value: timerBloc, child: const SecondTimer());
  }

  Widget editTimerIconButton(TimerBloc timerBloc) {
    return IconButton(
        onPressed: () async {
          TimeOfDay? pickedTimeOFDay = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(
                timerBloc.unredactedStartTime ?? DateTime.now()),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child ?? Container(),
              );
            },
          );
          DateTime now = DateTime.now();

          if (pickedTimeOFDay != null) {
            DateTime newStartTime = DateTime(now.year, now.month, now.day,
                pickedTimeOFDay.hour, pickedTimeOFDay.minute);
            log(newStartTime.toString(),
                name:
                    'Ошибся малыш уснул в, а не ${timerBloc.unredactedStartTime}:');
            if (timerBloc.unredactedStartTime != null) {
              log('IS it printed');
              timerBloc.add(TimerGetNewTimes(newDatetime: newStartTime));
            }
          }
        },
        icon: const Icon(Icons.edit));
  }

  String dateFormat(DateTime dateTime) {
    return '${dateTime.year}:${dateTime.month}:${dateTime.day} - ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  Widget playButton(TimerBloc timerBloc, TimerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {
              log(DateTime.now().toString(), name: 'Малыш уснул в :');
              state.timerStatus != TimerStatus.play
                  ? timerBloc.add(TimerStart(startDateTime: DateTime.now()))
                  : showDialogIfWasPressedCancel(timerBloc);
            },
            child: Text(state.timerStatus != TimerStatus.play
                ? 'Начать сон'
                : 'Завершить сон')),
        editTimerIconButton(timerBloc)
      ],
    );
  }

  Future<dynamic> showDialogIfWasPressedCancel(TimerBloc timerBloc) {
    return showDialog(
        context: context,
        builder: (context) {
          DateTime now = DateTime.now();

          return Dialog(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Малыш уснул в : ${dateFormat(timerBloc.unredactedStartTime!)}'),
                Text(
                    'Малыш проспал : ${_printDuration(now.difference(timerBloc.unredactedStartTime!))}'),
                Text('Малыш проснулся в : ${dateFormat(now)}'),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          timerBloc.add(TimerStop());
                        },
                        child: const Text('Сохранить')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Продолжить сон'))
                  ],
                )
              ],
            ),
          );
        });
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
