import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/custom_text.dart';
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

  late DateTime newPickedDateAndTime;

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
                  Text(
                      'Системное время: ${Validator().formatTheDateTime(DateTime.now())}'),
                  BlocProvider.value(
                      value: timerBloc, child: const CustomText()),
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
      return dateFormat(showDateTime);
    }
  }

  Widget onEditTimePressed(TimerBloc timerBloc) {
    return IconButton(
        onPressed: () async {
          DateTime now = DateTime.now();
          alertDialogWithDateAndTimeForStartSleep(timerBloc, now, context);
        },
        icon: const Icon(Icons.edit));
  }

  Future<dynamic> alertDialogWithDateAndTimeForStartSleep(
    TimerBloc timerBloc,
    DateTime now,
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
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

                      timerBloc.add(TimerGetNewTimes(
                        newDatetime: newPickedDateAndTime,
                        stopTime:
                            timerBloc.unredactedStopTime ?? DateTime.now(),
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
    DateTime stopTime = timerBloc.unredactedStopTime ?? DateTime.now();
    log(stopTime.toString(), name: 'Stop time');
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStater) {
          String contentText = "Content of Dialog";
          String startOrStop = '';
          return Dialog(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Малыш уснул в : ${Validator().formatTheDateTime(timerBloc.unredactedStartTime!)}'),
                Text(
                    'Малыш проспал : ${_printDuration(stopTime.difference(timerBloc.unredactedStartTime!))}'),
                Text(
                    'Малыш проснулся в : ${Validator().formatTheDateTime(stopTime)}'),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          timerBloc.add(TimerStop(dateTime: stopTime));
                        },
                        child: const Text('Сохранить')),
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, customSetStater) {
                                  return AlertDialog(
                                    title: Text(contentText),
                                    content: Row(
                                      children: [
                                        if (firstOrSecondAlertDialog == 'first')
                                          TextButton(
                                              onPressed: () {
                                                customSetStater(() {
                                                  firstOrSecondAlertDialog =
                                                      'second';
                                                  startOrStop = 'Start';
                                                });
                                              },
                                              child: const Text('Начало')),
                                        if (firstOrSecondAlertDialog == 'first')
                                          TextButton(
                                              onPressed: () {
                                                customSetStater(() {
                                                  firstOrSecondAlertDialog =
                                                      'second';
                                                  startOrStop = 'Stop';
                                                });
                                              },
                                              child: const Text('Конец')),
                                        if (firstOrSecondAlertDialog ==
                                            'second')
                                          TextButton(
                                              onPressed: () async {
                                                newPickedDate =
                                                    await _showDatePicker(
                                                        timerBloc);
                                              },
                                              child: const Text('Дата')),
                                        if (firstOrSecondAlertDialog ==
                                            'second')
                                          TextButton(
                                              onPressed: () async {
                                                newPickedTime =
                                                    await _showTimePicker(
                                                        timerBloc);
                                              },
                                              child: const Text('Время'))
                                      ],
                                    ),
                                    actions: [
                                      if (firstOrSecondAlertDialog == 'first')
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK')),
                                      if (firstOrSecondAlertDialog == 'second')
                                        TextButton(
                                            onPressed: () {
                                              DateTime now = DateTime.now();
                                              if (newPickedTime != null) {
                                                newPickedDate ??= now;
                                                newPickedTime ??
                                                    TimeOfDay.fromDateTime(now);

                                                newPickedDateAndTime = DateTime(
                                                    newPickedDate!.year,
                                                    newPickedDate!.month,
                                                    newPickedDate!.day,
                                                    newPickedTime!.hour,
                                                    newPickedTime!.minute);

                                                if (startOrStop == 'Stop') {
                                                  timerBloc.add(
                                                      TimerGetNewDateTimeForEnd(
                                                          newDatetime: timerBloc
                                                              .unredactedStartTime!,
                                                          stopTime:
                                                              newPickedDateAndTime,
                                                          now: now));
                                                } else {
                                                  timerBloc
                                                      .add(TimerGetNewTimes(
                                                    newDatetime:
                                                        newPickedDateAndTime,
                                                    stopTime: timerBloc
                                                            .unredactedStopTime ??
                                                        DateTime.now(),
                                                    now: now,
                                                  ));
                                                }
                                              }
                                              Navigator.of(context).pop();
                                              firstOrSecondAlertDialog =
                                                  'first';
                                            },
                                            child: const Text('ОК'))
                                    ],
                                  );
                                });
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
      },
    );
  }

  String firstOrSecondAlertDialog = 'first';

  Future<void> alertDialogPressed(
      TimerBloc timerBloc, String startOrStop) async {
    DateTime now = DateTime.now();

    if (newPickedTime != null) {
      newPickedDate ??= now;
      newPickedTime ?? TimeOfDay.fromDateTime(now);

      newPickedDateAndTime = DateTime(newPickedDate!.year, newPickedDate!.month,
          newPickedDate!.day, newPickedTime!.hour, newPickedTime!.minute);

      if (startOrStop == 'Stop') {
        timerBloc.add(TimerGetNewDateTimeForEnd(
            newDatetime: timerBloc.unredactedStartTime!,
            stopTime: newPickedDateAndTime,
            now: now));
      } else {
        timerBloc.add(TimerGetNewTimes(
          newDatetime: newPickedDateAndTime,
          stopTime: timerBloc.unredactedStopTime ?? DateTime.now(),
          now: now,
        ));
      }
    }
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
