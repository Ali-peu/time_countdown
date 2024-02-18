import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';

class DisplayTimer extends StatefulWidget {
  const DisplayTimer({super.key});

  @override
  State<DisplayTimer> createState() => _DisplayTimerState();
}

class _DisplayTimerState extends State<DisplayTimer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        if (state.timerStatus == TimerStatus.play) {
          return StreamBuilder(
              stream: context.read<TimerBloc>().timerService.timerStream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Text('00:00:00');
                } else {
                  return Text(Validator().printDuration(snapshot.data!));
                }
              });
        } else {
          return const Text('00:00:00');
        }
      },
    );
  }
}
