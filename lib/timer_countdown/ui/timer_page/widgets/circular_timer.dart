import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';

import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class CircularTimer extends StatefulWidget {
  
  final ValueChanged<Duration> onTimerPause;
  const CircularTimer({required this.onTimerPause, super.key});

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer> {
  @override
  Widget build(BuildContext context) {
    log('IF IT Rebuild?');
    var timerBloc = context.read<TimerBloc>();
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return TimerCountdown(
          enableDescriptions: false,
          format: CountDownTimerFormat.hoursMinutesSeconds,
          endTime: DateTime.now().add(state.timer),
          onTick: (timer) {
            widget.onTimerPause(timer);
            log(timer.inSeconds.toString());
          },
          onEnd: () {
            context.read<TimerBloc>().add(TimerStop());
            print("Timer finished");
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
