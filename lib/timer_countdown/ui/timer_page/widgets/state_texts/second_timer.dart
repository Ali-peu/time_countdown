import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/validator.dart';

class SecondTimer extends StatefulWidget {
  const SecondTimer({super.key});

  @override
  State<SecondTimer> createState() => _SecondTimerState();
}

class _SecondTimerState extends State<SecondTimer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final timerBloc = context.read<TimerBloc>();
        return StreamBuilder(
            stream: timerBloc.timerService.timerStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final duration = snapshot.data!;
                return Text(Validator().printDuration(duration));
              } else {
                return const Text(' 00:00:00');
              }
            });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    context.read<TimerBloc>().timerService.dispose();
  }
}
