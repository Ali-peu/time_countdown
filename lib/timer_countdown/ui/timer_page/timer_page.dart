import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/data/globals/globals.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_model.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_sleep_time_stat_model.dart';
import 'package:time_countdown/timer_countdown/domain/repository/child_sleep_time_stat_repository.dart';
import 'package:time_countdown/timer_countdown/domain/repository/children_repository.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';
import 'package:time_countdown/timer_countdown/ui/stats_page/stats_page.dart';

import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/second_timer.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Future<void> showStats() async {
    log('Снизу прямое обращение Stats к репозиторий в самом initState и его результать');
    await ChildSleepTimeStatRepository().getchildSleepTimeStats();
  }

  Future<void> createStats() async {
    log('Снизу прямое обращение Stats к репозиторий в самом initState и его результать');
    await ChildSleepTimeStatRepository().testInsert();
  }

  void deleteChild() {
    log('Удалякм таблицу');
    ChildrenRepository().deletaAll();
  }

  Future<void> createChilds() async {
    log('Снизу прямое обращение к репозиторий в самом initState и его результать : createChilds');
    await ChildrenRepository().testCreateChild();
  }

  Future<void> showChilds() async {
    log('Снизу прямое обращение к репозиторий в самом initState и его результать');
    await ChildrenRepository().testGetAllChild();
  }

  DateTime? newPickedDate;
  TimeOfDay? newPickedTime;

  late DateTime newPickedDateAndTime;
  ChildModel? chooseChildModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showChilds();
    showStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TimerBloc, TimerState>(
        listener: (context, state) {
          if (state.timerPageStatus == TimerPageStatus.failure) {
            // TODO Delete this
            showDialog(
                context: context,
                builder: (context) {
                  return const Dialog.fullscreen();
                });
          }

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.timerStatus.toString())));
        },
        child: BlocBuilder<TimerBloc, TimerState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<List<ChildSleepTimeStatModel>>(
                      future: Future.value(context
                          .read<TimerBloc>()
                          .state
                          .listChildSleepTimeStats),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const Text('snapthot.data == null');
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data!.isNotEmpty) {
                            final stats = snapshot.data!;
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(Validator().formatTheDateTime(
                                        stats[index].babySleepDateTime)),
                                    subtitle: Text(Validator()
                                        .formatTheDateTime(
                                            stats[index].babyWakeUpDateTime)),
                                    trailing: Text(Validator()
                                        .printDuration(stats[index].duration)),
                                    leading:
                                        Text(stats[index].babyId.toString()),
                                  );
                                },
                                itemCount: stats.length,
                              ),
                            );
                          } else {
                            return const Text('snapshot.data!.isEmpty');
                          }
                        } else {
                          return const Text('!snapshot.hasData');
                        }
                      }),
                  FutureBuilder<List<ChildModel>>(
                      future: Future.value(
                          context.read<TimerBloc>().state.listChildren),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const Text(
                              'no elements: snapshot.data == null)');
                        } else {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              final listChild = snapshot.data!;
                              if (chooseChildModel == null) {
                                log('chooseModel == null');
                                chooseChildModel = listChild.first;
                              }

                              return DropdownButton<ChildModel>(
                                  value: chooseChildModel,
                                  items: listChild.map((child) {
                                    return DropdownMenuItem<ChildModel>(
                                        value: child, child: Text(child.name));
                                  }).toList(),
                                  onChanged: (child) {
                                    chooseChildModel = child;
                                    setState(() {});
                                    log('OnChange ${child!.name}');

                                    log('OnChange ${chooseChildModel!.name}');
                                  });
                            } else {
                              return const Text(
                                  'snapshot has data, but its empty');
                            }
                          } else {
                            return const Text('snapshot not has data');
                          }
                        }
                      }),
                  Text(
                      'Системное время: ${Validator().formatTheDateTime(DateTime.now())}'),
                  if (state.timerStatus == TimerStatus.initial)
                    const Text('Малыш не спит'),
                  if (state.timerStatus == TimerStatus.play)
                    Text(
                        'Малыш уснул ${getRightTime(context.read<TimerBloc>().unredactedStartTime)}'),
                  if (state.timerStatus == TimerStatus.stop)
                    Column(
                      children: [
                        Text(
                            'Малыш уснул ${getRightTime(context.read<TimerBloc>().unredactedStartTime)}'),
                        Text(
                            'Малыш проснулся : ${getRightTime(context.read<TimerBloc>().unredactedStopTime)} ')
                      ],
                    ),
                  timerInState(),
                  playButton(state)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String getRightTime(DateTime? dateTime) {
    DateTime showDateTime = DateTime.now();
    if (dateTime == null) {
      return 'Не уснул';
    } else {
      showDateTime = dateTime;
      return Validator().formatTheDateTime(showDateTime);
    }
  }

  Widget onEditTimePressed() {
    return IconButton(
        onPressed: () async {
          DateTime now = DateTime.now();
          alertDialogWithDateAndTimeForStartSleep(now, context);
        },
        icon: const Icon(Icons.edit));
  }

  Future<dynamic> alertDialogWithDateAndTimeForStartSleep(
    DateTime now,
    BuildContext context,
  ) {
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

  BlocProvider<TimerBloc> timerInState() {
    return BlocProvider.value(
        value: context.read<TimerBloc>(), child: const SecondTimer());
  }

  Widget playButton(TimerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {
              state.timerStatus != TimerStatus.play
                  ? context
                      .read<TimerBloc>()
                      .add(TimerStart(startDateTime: DateTime.now()))
                  : showDialogIfWasPressedCancel();
            },
            child: Text(state.timerStatus != TimerStatus.play
                ? 'Начать сон'
                : 'Завершить сон')),
        onEditTimePressed()
      ],
    );
  }

  Future<dynamic> showDialogIfWasPressedCancel() {
    DateTime stopTime =
        context.read<TimerBloc>().unredactedStopTime ?? DateTime.now();
    log(stopTime.toString(), name: 'Stop time');
    return showDialog(
        context: context,
        builder: (_) {
          String contentText = "Content of Dialog";
          String startOrStop = '';
          return Dialog(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Малыш уснул в : ${Validator().formatTheDateTime(context.read<TimerBloc>().unredactedStartTime!)}'),
                Text(
                    'Малыш проспал : ${Validator().printDuration(stopTime.difference(context.read<TimerBloc>().unredactedStartTime!))}'),
                Text(
                    'Малыш проснулся в : ${Validator().formatTheDateTime(stopTime)}'),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<TimerBloc>().add(TimerStop(
                              dateTime: stopTime,
                              babyID: chooseChildModel!.childId));
                        },
                        child: const Text('Сохранить')),
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                var timerBloc = context.read<TimerBloc>();
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
                                              Navigator.pop(context);
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
