import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/buttons/edit_icon.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/stateful_dialog.dart';

class ButtonToEditTimer extends StatefulWidget {
  const ButtonToEditTimer({super.key});

  @override
  State<ButtonToEditTimer> createState() => _ButtonToEditTimerState();
}

class _ButtonToEditTimerState extends State<ButtonToEditTimer> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: showDialogIfWasPressedCancel,
        child: Row(
          children: [
            const Text('Завершить сон'),
            BlocProvider.value(
              value: context.read<TimerBloc>(),
              child: const EditIcon(),
            )
          ],
        ));
  }

  Future<dynamic> showDialogIfWasPressedCancel() {
    final stopTime =
        context.read<TimerBloc>().unredactedStopTime ?? DateTime.now();
    return showDialog(
        context: context,
        builder: (_) {
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
                              babyID: context
                                  .read<TimerBloc>()
                                  .pickedBabyId!)); // TODO Проверить что бы этот переменная сохранилась
                        },
                        child: const Text('Сохранить')),
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return BlocProvider.value(
                                  value: context.read<TimerBloc>(),
                                  child: const StatefulDialog(),
                                );
                              });
                        },
                        child: const Text('Редактировать')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
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
