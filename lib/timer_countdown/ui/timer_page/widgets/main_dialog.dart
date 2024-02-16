import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';
import 'package:time_countdown/timer_countdown/ui/timer_page/widgets/stateful_dialog.dart';

class MainDialog extends StatefulWidget {
  const MainDialog({super.key});

  @override
  State<MainDialog> createState() => _MainDialogState();
}

class _MainDialogState extends State<MainDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Малыш уснул в : ${Validator().formatTheDateTime(context.read<TimerBloc>().state.babySleepTime)}'),
              Text(
                  'Малыш проспал : ${Validator().printDuration(context.read<TimerBloc>().state.babyWakeUpTime.difference(context.read<TimerBloc>().state.babySleepTime))}'),
              Text(
                  'Малыш проснулся в : ${Validator().formatTheDateTime(context.read<TimerBloc>().state.babyWakeUpTime)}'),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<TimerBloc>().add(TimerStop(
                            dateTime:
                                context.read<TimerBloc>().state.babyWakeUpTime,
                            babyID:
                                context.read<TimerBloc>().state.choosenBabyId));
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
                        context.read<TimerBloc>().add(UpdateDefautlState(
                            stopTime: context
                                .read<TimerBloc>()
                                .state
                                .babyWakeUpTime));
                        Navigator.of(context).pop();
                      },
                      child: const Text('Продолжить'))
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
