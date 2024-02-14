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

  DateTime? pickedStartTime;

  DateTime? newPickedDate;
  TimeOfDay? newPickedTime;

  late DateTime newPickedDateAndTime; // TODO

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TimerBloc, TimerState>(
        listener: (context, state) {
          if (state.result.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.result)));
          }
        },
        child: BlocBuilder<TimerBloc, TimerState>(
          builder: (context, state) {
            var timerBloc = context.read<TimerBloc>();
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Малыш уснул в ${getRightTime(timerBloc)}'),
                  timerInState(timerBloc),
                  playButton(timerBloc, state)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String getRightTime(TimerBloc timerBloc) {
    DateTime showDateTime;
    if (timerBloc.unredactedStartTime == null) {
      return 'Не уснул';
    } else {
      showDateTime = timerBloc.unredactedStartTime!;
      log(showDateTime.toString(), name: 'ShowDateTime in State');
      // setState(() {});
      return dateFormat(showDateTime);
    }
  }

  Widget onEditTimePressed(TimerBloc timerBloc) {
    return IconButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                DateTime now = DateTime.now();
                return alertDialogWithDateAndTimeForStartSleep(
                    timerBloc, now, context, 'Start');
              });
        },
        icon: const Icon(Icons.edit));
  }

  AlertDialog alertDialogWithDateAndTimeForStartSleep(TimerBloc timerBloc,
      DateTime now, BuildContext context, String startOrStop) {
    // что тут проиходит
    // создаю время начало сна малыша и по нему запускаю таймер
    return AlertDialog(
      title: const Text("Выберите дату сна"),
      content: Row(
        children: [
          TextButton(
              onPressed: () async {
                newPickedDate = await _showDatePicker(timerBloc);
              },
              child: const Text('День')),
          TextButton(
              onPressed: () async {
                newPickedTime = await _showTimePicker(timerBloc);
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

                log(newPickedDateAndTime.toString(),
                    name: 'New Picked Date And Time: ');

                log(newPickedDateAndTime.isBefore(now).toString(),
                    name: 'newPickedDate!.isBefore(now):');
               if (startOrStop == 'Stop') {
                  log('Устанавливаю время конец сна');
                  timerBloc.add(TimerGetNewTimes(
                      newDatetime: timerBloc.unredactedStartTime!,
                      stopTime: newPickedDateAndTime,
                      startOrStop: 'Stop'));
                } else {
                  if (newPickedDateAndTime.isBefore(now)) {
                    log('TimerGetNewTimes is done');
                    if (startOrStop == 'Start') {
                      log('Устанавливаю начальное время');
                      timerBloc.add(TimerGetNewTimes(
                          newDatetime: newPickedDateAndTime,
                          stopTime: DateTime.now(),
                          startOrStop: 'Start'));
                    }

                    setState(
                        () {}); // TODO вызывается для обнавление Text(время начало сна малыша) в State
                  } else {
                    log('TimerError is done');
                    timerBloc.add(TimerError());
                  }
                }

                Navigator.pop(context);
              }
            },
            child: const Text('ОК')),
      ],
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

    return await showTimePicker(
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

  BlocProvider<TimerBloc> timerInState(TimerBloc timerBloc) {
    return BlocProvider.value(value: timerBloc, child: const SecondTimer());
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
        onEditTimePressed(timerBloc)
      ],
    );
  }

  Future<dynamic> showDialogIfWasPressedCancel(TimerBloc timerBloc) {
    context.read<TimerBloc>().add(TimerStopTimeSave(stopTime: DateTime.now()));
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
                Text(
                    'Малыш проснулся в : ${dateFormat(timerBloc.unredactedStopTime!)}'),
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
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Редактировать время'),
                                  content: Row(
                                    children: [
                                      TextButton(
                                          onPressed: () async {
                                            // НУжно обнавить время начало сна у малыша
                                            // Он у меня храниться в самом блоке
                                            //И наддо просто его обнавитть
                                            //Но также должен меняться само таймер потому что потому
                                            //Поэтому вызываем метод для обнавление таймер, мы получили новое таймер
                                            //Но сперва надо получить новый тайм
                                            DateTime now = DateTime.now();
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return alertDialogWithDateAndTimeForStartSleep(
                                                      timerBloc,
                                                      now,
                                                      context,
                                                      'Start');
                                                });
                                          },
                                          child: const Text('Начало')),
                                      TextButton(
                                          onPressed: () async {
                                            DateTime now = DateTime.now();
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return alertDialogWithDateAndTimeForStartSleep(
                                                      timerBloc,
                                                      now,
                                                      context,
                                                      'Stop'); //TODO Stop
                                                });
                                          },
                                          child: const Text('Конец сна'))
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'))
                                  ],
                                );
                              });
                        },
                        child: const Text('Редактировать')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Продолжить'))
                  ],
                )
              ],
            ),
          );
        });
  }
}

String _printDuration(Duration duration) {
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

String dateFormat(DateTime dateTime) {
  String twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }

  return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} - ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}';
}
